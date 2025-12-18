import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/doctor_subscription_info_api.dart';
import 'package:one/models/doctor_subscription.dart';

class PxDocSubscriptionInfo extends ChangeNotifier {
  final DoctorSubscriptionInfoApi api;

  PxDocSubscriptionInfo({required this.api}) {
    _fetchDoctorSubscriptionInfo();
  }

  static ApiResult<List<DoctorSubscription>>? _result;
  ApiResult<List<DoctorSubscription>>? get result => _result;

  Future<void> retry() async => await _fetchDoctorSubscriptionInfo();

  Future<void> _fetchDoctorSubscriptionInfo() async {
    _result = await api.fetchDoctorSubscriptionInfo();
    notifyListeners();
  }

  bool get hasAciveSubscriptions =>
      _result != null &&
      _result is ApiDataResult<List<DoctorSubscription>> &&
      (_result as ApiDataResult<List<DoctorSubscription>>).data.any(
        (e) => e.subscription_status == 'active',
      );

  bool get hasNoAciveSubscriptions =>
      _result != null &&
      _result is ApiDataResult<List<DoctorSubscription>> &&
      (_result as ApiDataResult<List<DoctorSubscription>>).data.any(
        (e) => e.subscription_status != 'active',
      );

  bool get hasGracePeriodSubscription =>
      _result != null &&
      _result is ApiDataResult<List<DoctorSubscription>> &&
      (_result as ApiDataResult<List<DoctorSubscription>>).data.any(
        (e) => e.inGracePeriod,
      );
}
