import 'package:one/annotations/pb_annotations.dart';
import 'package:one/models/visits/visit.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';

@PbData()
class VisitFilterApi {
  const VisitFilterApi();

  static const String collection = 'visits';

  static const String _expand = 'doc_id, clinic_id, patient_id';

  Future<ApiResult<List<VisitExpanded>>> fetctVisitsOfDateRange({
    required String from,
    required String to,
  }) async {
    try {
      final _response = await PocketbaseHelper.pbData
          .collection(collection)
          .getFullList(
            filter: "visit_date >= '$from' && visit_date <= '$to'",
            sort: '-visit_date',
            expand: _expand,
          );

      final _visits = _response.map((e) {
        return VisitExpanded.fromRecordModel(e);
      }).toList();

      return ApiDataResult<List<VisitExpanded>>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<VisitExpanded>> fetchOneExpandedVisit(
    String visit_id,
  ) async {
    try {
      final _response = await PocketbaseHelper.pbData
          .collection(collection)
          .getOne(
            visit_id,
            expand: _expand,
          );

      final _visits = VisitExpanded.fromRecordModel(_response);

      return ApiDataResult<VisitExpanded>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
