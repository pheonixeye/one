import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/models/visits/visit.dart';
import 'package:pocketbase/pocketbase.dart';

class PatientPortalApi {
  const PatientPortalApi({
    required this.org_id,
    required this.patient_id,
  });

  final String? org_id;
  final String? patient_id;

  @PbBase()
  Future<ApiResult<Organization>> fetchOrganization() async {
    if (org_id == null) {
      return ApiErrorResult<Organization>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: AppErrorCode.clientException.name,
      );
    }
    try {
      final _result = await PocketbaseHelper.pbBase
          .collection('organizations')
          .getOne(org_id!);
      final _data = Organization.fromJson(_result.toJson());

      return ApiDataResult<Organization>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @PbPortal()
  Future<ApiResult<Patient>> fetchPatient() async {
    if (patient_id == null) {
      return ApiErrorResult<Patient>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: AppErrorCode.clientException.name,
      );
    }
    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('patients')
          .getOne(patient_id!);
      final _data = Patient.fromJson(_result.toJson());

      return ApiDataResult<Patient>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  static const _visitsExpand = 'doc_id, clinic_id, patient_id';

  @PbPortal()
  Future<ApiResult<List<VisitExpanded>>> fetchVisitsOfOnePatient() async {
    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('visits')
          .getFullList(
            filter: 'patient_id = "$patient_id"',
            expand: _visitsExpand,
            sort: '-created',
          );
      final _data = _result
          .map((e) => VisitExpanded.fromRecordModel(e))
          .toList();

      return ApiDataResult<List<VisitExpanded>>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @PbPortal()
  Future<ApiResult<List<PatientDocumentWithDocumentType>>> fetchVisitDocuments({
    required String visit_id,
  }) async {
    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('patient__documents')
          .getFullList(
            filter:
                'patient_id = "$patient_id" && related_visit_id = "$visit_id"',
            expand: 'document_type_id',
            sort: '-created',
          );
      final _data = _result
          .map((e) => PatientDocumentWithDocumentType.fromRecordModel(e))
          .toList();

      return ApiDataResult<List<PatientDocumentWithDocumentType>>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> bookNewVisit() async {
    //TODO:
  }
}
