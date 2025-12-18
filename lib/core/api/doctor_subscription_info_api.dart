import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/functions/dprint.dart';
import 'package:one/models/doctor_subscription.dart';

class DoctorSubscriptionInfoApi {
  final String doc_id;

  DoctorSubscriptionInfoApi({required this.doc_id});

  static const String collection = 'doctor_subscriptions';

  static bool _activeSubscriptionsChecked = false;

  static const String _expand = 'payment_id';

  Future<void> _checkDoctorSubscriptionStatus() async {
    if (_activeSubscriptionsChecked == false) {
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getFullList(
            filter: "doc_id = '$doc_id' && subscription_status = 'active'",
          );

      final _items = _response
          .map((e) => DoctorSubscription.fromJson(e.toJson()))
          .toList();

      _items.map((e) async {
        if (e.passedExpirationTime) {
          final _toExpire = e.copyWith(subscription_status: 'expired');
          await PocketbaseHelper.pb
              .collection(collection)
              .update(e.id, body: _toExpire.toJson());
        }
      }).toList();
    }

    _activeSubscriptionsChecked = true;
    dprint(
      'DoctorSubscriptionInfoApi($doc_id).__checkDoctorSubscriptionStatus($_activeSubscriptionsChecked))',
    );
  }

  Future<ApiResult<List<DoctorSubscription>>>
  fetchDoctorSubscriptionInfo() async {
    await _checkDoctorSubscriptionStatus();
    try {
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getFullList(
            filter: "doc_id = '$doc_id'",
            sort: '-created',
            expand: _expand,
          );
      final _result = _response
          .map(
            (e) => DoctorSubscription.fromJson({
              ...e.toJson(),
              'payment': e.get<RecordModel?>('expand.payment_id')?.toJson(),
            }),
          )
          .toList();
      // prettyPrint(_result);
      return ApiDataResult<List<DoctorSubscription>>(data: _result);
    } catch (e) {
      return ApiErrorResult<List<DoctorSubscription>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
