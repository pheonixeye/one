import 'package:one/annotations/pb_annotations.dart';
import 'package:one/models/visits/visit.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';

@PbData()
class VisitFilterApi {
  const VisitFilterApi();
  //TODO: add all filter params to the request

  static const String collection = 'visits';

  Future<ApiResult<List<Visit>>> fetctVisitsOfDateRange({
    required String from,
    required String to,
  }) async {
    try {
      final _response = await PocketbaseHelper.pbData
          .collection(collection)
          .getFullList(
            filter: "visit_date >= '$from' && visit_date <= '$to'",
            sort: '-visit_date',
          );

      final _visits = _response.map((e) {
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
