import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/s3_patient_documents_api.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:flutter/material.dart';
import 'package:one/providers/px_s3_documents.dart';
import 'package:provider/provider.dart';

class PxS3PatientDocuments extends ChangeNotifier {
  final S3PatientDocumentApi api;
  final String? visit_id;
  final BuildContext context;

  PxS3PatientDocuments({
    required this.api,
    this.visit_id,
    required this.context,
  }) {
    _init();
  }

  ApiResult<List<PatientDocument>>? _documents;
  ApiResult<List<PatientDocument>>? get documents => _documents;

  List<PatientDocument>? _filteredDocuments;
  // List<PatientDocument>? get filteredDocuments => _filteredDocuments;

  Map<DateTime, List<PatientDocument>>? _groupedDocuments;
  Map<DateTime, List<PatientDocument>>? get groupedDocuments =>
      _groupedDocuments;

  Future<void> _init() async {
    _documents = visit_id == null
        ? await api.fetchPatientDocuments()
        : await api.fetchPatientDocumentsOfOneVisit(visit_id!);
    notifyListeners();
    _filteredDocuments =
        (_documents as ApiDataResult<List<PatientDocument>>).data;
    notifyListeners();
  }

  Future<void> retry() async => await _init();

  Future<void> addPatientDocument({
    required PatientDocument document,
    required dynamic payload,
    required String objectName,
  }) async {
    final s3 = context.read<PxS3Documents>();
    final uploadResultObjectName = await s3.uploadDocument(
      objectName: objectName,
      payload: payload,
    );
    await api.addPatientDocument(document);
    await _init();
  }

  void filterAndGroup(String documentTypeId) {
    _filteredDocuments = (_documents as ApiDataResult<List<PatientDocument>>)
        .data
        .where(
          (e) {
            return e.document_type_id == documentTypeId;
          },
        )
        .toList();

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
