import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/visits/_visit.dart';
import 'package:pocketbase/pocketbase.dart';

class PatientPreviousVisitsApi {
  final String patient_id;

  PatientPreviousVisitsApi({required this.patient_id});

  static const collection = 'visits';

  static const _expand =
      'patient_id, clinic_id, added_by_id, added_by_id.account_type_id, added_by_id.app_permissions_ids, visit_status_id, visit_type_id, patient_progress_status_id, doc_id, doc_id.speciality_id, visit_schedule_id';

  Future<ApiResult<List<Visit>>> fetchPatientVisits({
    required int page,
    int perPage = 10,
  }) async {
    try {
      // print(_todayFormatted);
      final _result = await PocketbaseHelper.pb
          .collection(collection)
          .getList(
            page: page,
            perPage: perPage,
            filter: "patient_id = '$patient_id'",
            expand: _expand,
            sort: '-visit_date',
          );

      final _visits = _result.items.map((e) {
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
}
