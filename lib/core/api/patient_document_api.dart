import 'dart:typed_data';

import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/patient_document/expanded_patient_document.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

class PatientDocumentApi {
  const PatientDocumentApi({required this.patient_id});
  final String patient_id;

  static const collection = 'patient__documents';
  //TODO: refactor this expand - too much info requested
  static const _expandList = [
    'patient_id',
    'document_type_id',
    'related_visit_id',
    'related_visit_id.patient_id',
    'related_visit_id.clinic_id',
    'related_visit_id.added_by_id',
    'related_visit_id.added_by_id.account_type_id',
    'related_visit_id.added_by_id.app_permissions_ids',
    'related_visit_id.visit_status_id',
    'related_visit_id.visit_type_id',
    'related_visit_id.visit_schedule_id',
    'related_visit_id.patient_progress_status_id',
    'related_visit_id.doc_id',
    'related_visit_id.doc_id.speciality_id',
    'related_visit_data_id',
    'related_visit_data_id.patient_id',
    'related_visit_data_id.labs_ids',
    'related_visit_data_id.rads_ids',
    'related_visit_data_id.procedures_ids',
    'related_visit_data_id.drugs_ids',
    'related_visit_data_id.supplies_ids',
    'related_visit_data_id.form_data_ids',
    'related_visit_data_id.form_data_ids.form_id',
  ];
  static final String _expand = _expandList.join(',');

  Future<ApiResult<ExpandedPatientDocument>> addPatientDocument(
    PatientDocument document,
    Uint8List file_bytes,
    String filename,
  ) async {
    try {
      final _result = await PocketbaseHelper.pbBase
          .collection(collection)
          .create(
            body: document.toJson(),
            files: [
              http.MultipartFile.fromBytes(
                'document',
                file_bytes,
                filename: filename,
              ),
            ],
            expand: _expand,
          );
      final _patientDoc = ExpandedPatientDocument.fromRecordModel(_result);

      return ApiDataResult<ExpandedPatientDocument>(data: _patientDoc);
    } on ClientException catch (e) {
      return ApiErrorResult<ExpandedPatientDocument>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<ExpandedPatientDocument>>>
  fetchPatientDocuments() async {
    try {
      final _result = await PocketbaseHelper.pbBase
          .collection(collection)
          .getFullList(filter: "patient_id = '$patient_id'", expand: _expand);

      final _docs = _result
          .map((e) => ExpandedPatientDocument.fromRecordModel(e))
          .toList();

      return ApiDataResult<List<ExpandedPatientDocument>>(data: _docs);
    } on ClientException catch (e) {
      return ApiErrorResult<List<ExpandedPatientDocument>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<ExpandedPatientDocument>>>
  fetchPatientDocumentsOfOneVisit(String visit_id) async {
    try {
      final _result = await PocketbaseHelper.pbBase
          .collection(collection)
          .getFullList(
            filter:
                "patient_id = '$patient_id' && related_visit_id = '$visit_id'",
            expand: _expand,
          );

      final _docs = _result
          .map((e) => ExpandedPatientDocument.fromRecordModel(e))
          .toList();

      return ApiDataResult<List<ExpandedPatientDocument>>(data: _docs);
    } on ClientException catch (e) {
      return ApiErrorResult<List<ExpandedPatientDocument>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
