import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/subscription_api.dart';
import 'package:one/models/subscription.dart';

class PxSubscription extends ChangeNotifier {
  final SubscriptionApi api;

  PxSubscription({required this.api}) {
    _fetchDoctorSubscriptionInfo();
  }

  static ApiResult<List<Subscription>>? _result;
  ApiResult<List<Subscription>>? get result => _result;

  Future<void> retry() async => await _fetchDoctorSubscriptionInfo();

  Future<void> _fetchDoctorSubscriptionInfo() async {
    _result = await api.fetchDoctorSubscriptionInfo();
    notifyListeners();
  }

  bool get hasAciveSubscriptions =>
      _result != null &&
      _result is ApiDataResult<List<Subscription>> &&
      (_result as ApiDataResult<List<Subscription>>).data.any(
        (e) => e.subscription_status == 'active',
      );

  bool get hasNoAciveSubscriptions =>
      _result != null &&
      _result is ApiDataResult<List<Subscription>> &&
      (_result as ApiDataResult<List<Subscription>>).data.any(
        (e) => e.subscription_status != 'active',
      );

  bool get hasGracePeriodSubscription =>
      _result != null &&
      _result is ApiDataResult<List<Subscription>> &&
      (_result as ApiDataResult<List<Subscription>>).data.any(
        (e) => e.inGracePeriod,
      );
}
