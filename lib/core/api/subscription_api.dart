import 'package:one/annotations/pb_annotations.dart';
import 'package:one/models/subscriptions/subscription.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';

@PbBase()
class SubscriptionApi {
  final String org_id;

  SubscriptionApi({required this.org_id});

  static const String collection = 'subscriptions';

  static const String _expand = 'payment_id, plan_id';

  Future<ApiResult<SubscriptionExpanded>>
  fetchOrganizationSubscriptionInfo() async {
    try {
      final _response = await PocketbaseHelper.pbBase
          .collection(collection)
          .getFirstListItem(
            'org_id = "$org_id"',
            expand: _expand,
          );
      final _result = SubscriptionExpanded.fromRecordModel(_response);
      // prettyPrint(_result);
      return ApiDataResult<SubscriptionExpanded>(data: _result);
    } catch (e) {
      return ApiErrorResult<SubscriptionExpanded>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
