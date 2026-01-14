import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/s3_patient_documents_api.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:flutter/material.dart';
import 'package:one/providers/px_s3_documents.dart';
import 'package:provider/provider.dart';

class PxS3PatientDocuments extends ChangeNotifier {
  final S3PatientDocumentApi api;
  final BuildContext context;
  final S3PatientDocumentsPxState state;

  PxS3PatientDocuments({
    required this.api,
    required this.context,
    this.state = S3PatientDocumentsPxState.none,
  }) {
    _init();
  }

  Future<void> _init() async {
    switch (state) {
      case S3PatientDocumentsPxState.documents_one_patient:
        await _fetchOnePatientDocuments();
        break;
      case S3PatientDocumentsPxState.documents_one_visit_one_patient:
        await _fetchOnePatientOneVisitDocuments();
        break;
      case S3PatientDocumentsPxState.none:
        break;
    }
    _filteredDocuments =
        (_documents as ApiDataResult<List<PatientDocument>>?)?.data;
    notifyListeners();
  }

  Future<void> retry() async => await _init();

  Future<void> _fetchOnePatientDocuments() async {
    _documents = await api.fetchPatientDocuments();
  }

  Future<void> _fetchOnePatientOneVisitDocuments() async {
    _documents = await api.fetchPatientDocumentsOfOneVisit();
  }

  ApiResult<List<PatientDocument>>? _documents;
  ApiResult<List<PatientDocument>>? get documents => _documents;

  List<PatientDocument>? _filteredDocuments;

  Map<DateTime, List<PatientDocument>>? _groupedDocuments;
  Map<DateTime, List<PatientDocument>>? get groupedDocuments =>
      _groupedDocuments;

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
    final _newDocument = document.copyWith(
      document_url: uploadResultObjectName,
    );
    await api.addPatientDocument(_newDocument);
  }

  void filterAndGroup(String documentTypeId) {
    _filteredDocuments = (_documents as ApiDataResult<List<PatientDocument>>)
        .data
        .where((e) {
          return e.document_type_id == documentTypeId;
        })
        .toList();

    _filteredDocuments?.sort((a, b) => b.created.compareTo(a.created));

    _groupedDocuments = Map.fromEntries(
      _filteredDocuments!.map((doc) {
        //todo: check grouping implementation
        final date = doc.created;
        final key = DateTime(date.year, date.month, date.day);
        return MapEntry(key, [
          ..._filteredDocuments!.where((e) {
            final _date1 = DateTime(
              date.year,
              date.month,
              date.day,
            );
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

enum S3PatientDocumentsPxState {
  documents_one_patient,
  documents_one_visit_one_patient,
  none,
}
