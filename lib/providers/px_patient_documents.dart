import 'dart:typed_data';

import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/patient_document_api.dart';
import 'package:one/models/patient_document/expanded_patient_document.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:flutter/material.dart';

class PxPatientDocuments extends ChangeNotifier {
  final PatientDocumentApi api;
  final String? visit_id;

  PxPatientDocuments({required this.api, this.visit_id}) {
    _init();
  }

  ApiResult<List<ExpandedPatientDocument>>? _documents;
  ApiResult<List<ExpandedPatientDocument>>? get documents => _documents;

  List<ExpandedPatientDocument>? _filteredDocuments;
  // List<ExpandedPatientDocument>? get filteredDocuments => _filteredDocuments;

  Map<DateTime, List<ExpandedPatientDocument>>? _groupedDocuments;
  Map<DateTime, List<ExpandedPatientDocument>>? get groupedDocuments =>
      _groupedDocuments;

  Future<void> _init() async {
    _documents = visit_id == null
        ? await api.fetchPatientDocuments()
        : await api.fetchPatientDocumentsOfOneVisit(visit_id!);
    notifyListeners();
    _filteredDocuments =
        (_documents as ApiDataResult<List<ExpandedPatientDocument>>).data;
    notifyListeners();
  }

  Future<void> retry() async => await _init();

  Future<void> addPatientDocument(
    PatientDocument document,
    Uint8List file_bytes,
    String filename,
  ) async {
    await api.addPatientDocument(document, file_bytes, filename);
    await _init();
  }

  void filterAndGroup(String documentTypeId) {
    _filteredDocuments =
        (_documents as ApiDataResult<List<ExpandedPatientDocument>>).data.where(
          (e) {
            return e.documentType.id == documentTypeId;
          },
        ).toList();

    _filteredDocuments?.sort((a, b) => b.created.compareTo(a.created));

    _groupedDocuments = Map.fromEntries(
      _filteredDocuments!.map((doc) {
        //todo: check grouping implementation
        final date = doc.created;
        final key = DateTime(date.year, date.month, date.day);
        return MapEntry(key, [
          ..._filteredDocuments!.where((e) {
            final _date1 = DateTime(date.year, date.month, date.day);
            final _date2 = DateTime(
              e.created.year,
              e.created.month,
              e.created.day,
            );
            return _date1.isAtSameMomentAs(_date2);
          }),
        ]);
      }),
    );

    notifyListeners();
  }
}
