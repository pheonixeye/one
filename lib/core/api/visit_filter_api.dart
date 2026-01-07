import 'package:one/models/visits/concised_visit.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/visits/_visit.dart';

class VisitFilterApi {
  const VisitFilterApi();

  static const String collection = 'visits';

  static const String _expand =
      'patient_id, clinic_id, added_by_id, added_by_id.account_type_id, added_by_id.app_permissions_ids, visit_status_id, visit_type_id, patient_progress_status_id, doc_id, doc_id.speciality_id, visit_schedule_id';

  static const String _concisedexpand =
      'patient_id, added_by_id, visit_schedule_id';

  Future<ApiResult<List<Visit>>> fetctVisitsOfDateRange({
    required String from,
    required String to,
  }) async {
    try {
      final _response = await PocketbaseHelper.pbBase
          .collection(collection)
          .getFullList(
            filter: "visit_date >= '$from' && visit_date <= '$to'",
            sort: '-visit_date',
            expand: _expand,
          );

      final _visits = _response.map((e) {
        return Visit.fromRecordModel(e);
      }).toList();

      return ApiDataResult<List<Visit>>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<ConcisedVisit>>> fetctConcisedVisitsOfDateRange({
    required String from,
    required String to,
  }) async {
    try {
      final _response = await PocketbaseHelper.pbBase
          .collection(collection)
          .getFullList(
            filter: "visit_date >= '$from' && visit_date <= '$to'",
            sort: '-visit_date',
            expand: _concisedexpand,
          );

      final _visits = _response.map((e) {
        return ConcisedVisit.fromRecordModel(e);
      }).toList();

      return ApiDataResult<List<ConcisedVisit>>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<Visit>> fetchOneExpandedVisit(String visit_id) async {
    try {
      final _response = await PocketbaseHelper.pbBase
          .collection(collection)
          .getOne(visit_id, expand: _expand);

      final _visit = Visit.fromRecordModel(_response);

      return ApiDataResult<Visit>(data: _visit);
    } on ClientException catch (e) {
      return ApiErrorResult<Visit>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
