import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/notifications/tokenized_notification.dart';
import 'package:pocketbase/pocketbase.dart';

@PbData()
class PbNotificationsApi {
  const PbNotificationsApi();

  static const collection = 'notifications';

  Future<ApiResult<List<TokenizedNotification>>> fetchNotifications({
    required int page,
    required int perPage,
  }) async {
    try {
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .getList(
            perPage: perPage,
            page: page,
            sort: '-created',
          );

      final _data = _result.items
          .map((e) => TokenizedNotification.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<TokenizedNotification>>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<TokenizedNotification>> markNotificationAsReadByUser({
    required TokenizedNotification notification,
    required String user_id,
  }) async {
    if (notification.read_by.contains(user_id)) {
      return ApiDataResult<TokenizedNotification>(data: notification);
    }
    try {
      final _update = [...notification.read_by, user_id];
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .update(
            notification.id,
            body: {
              'read_by': _update,
            },
          );

      final _data = TokenizedNotification.fromJson(_result.toJson());

      return ApiDataResult<TokenizedNotification>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<UnsubscribeFunc> notificationsSubscription(
    void Function(RecordSubscriptionEvent) callback,
  ) async {
    final sub = await PocketbaseHelper.pbData
        .collection(collection)
        .subscribe(
          '*',
          callback,
        );
    return sub;
  }
}
