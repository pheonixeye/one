import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:pocketbase/pocketbase.dart';

@PbData()
class S3PatientDocumentApi {
  const S3PatientDocumentApi({required this.patient_id});
  final String patient_id;

  static const collection = 'patient__documents';

  Future<ApiResult<PatientDocument>> addPatientDocument(
    PatientDocument document,
  ) async {
    try {
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .create(
            body: document.toJson(),
          );

      final _patientDoc = PatientDocument.fromJson(_result.toJson());

      return ApiDataResult<PatientDocument>(data: _patientDoc);
    } on ClientException catch (e) {
      return ApiErrorResult<PatientDocument>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<PatientDocument>>> fetchPatientDocuments() async {
    try {
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .getFullList(filter: "patient_id = '$patient_id'");

      final _docs = _result
          .map((e) => PatientDocument.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<PatientDocument>>(data: _docs);
    } on ClientException catch (e) {
      return ApiErrorResult<List<PatientDocument>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<PatientDocument>>> fetchPatientDocumentsOfOneVisit(
    String visit_id,
  ) async {
    try {
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .getFullList(
            filter:
                "patient_id = '$patient_id' && related_visit_id = '$visit_id'",
          );

      final _docs = _result
          .map((e) => PatientDocument.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<PatientDocument>>(data: _docs);
    } on ClientException catch (e) {
      return ApiErrorResult<List<PatientDocument>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
