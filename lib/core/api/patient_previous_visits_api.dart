import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/visits/visit.dart';
import 'package:pocketbase/pocketbase.dart';

@PbData()
class PatientPreviousVisitsApi {
  final String patient_id;

  PatientPreviousVisitsApi({required this.patient_id});

  static const collection = 'visits';

  Future<ApiResult<List<Visit>>> fetchPatientVisits({
    required int page,
    int perPage = 10,
  }) async {
    try {
      // print(_todayFormatted);
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .getList(
            page: page,
            perPage: perPage,
            filter: "patient_id = '$patient_id'",
            sort: '-visit_date',
          );

      final _visits = _result.items.map((e) {
        return Visit.fromJson(e.toJson());
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
