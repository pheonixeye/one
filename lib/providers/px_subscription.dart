import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/subscription_api.dart';
import 'package:one/models/notifications/client_notification.dart';
import 'package:one/models/subscriptions/subscription.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_firebase_notifications.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class PxSubscription extends ChangeNotifier {
  final SubscriptionApi api;
  final BuildContext context;

  PxSubscription({
    required this.api,
    required this.context,
  }) {
    init();
  }

  Future<void> init() async {
    await _fetchOrganizationSubscriptionInfo().whenComplete(() {
      _setSubscriptionState();
      notifyIfInGracePeriod();
    });
  }

  static ApiResult<SubscriptionExpanded>? _result;
  ApiResult<SubscriptionExpanded>? get result => _result;

  Future<void> retry() async => await _fetchOrganizationSubscriptionInfo();

  Future<void> _fetchOrganizationSubscriptionInfo() async {
    _result = await api.fetchOrganizationSubscriptionInfo();
    notifyListeners();
  }

  bool get hasAciveSubscriptions =>
      _result != null &&
      _result is ApiDataResult<SubscriptionExpanded> &&
      (_result as ApiDataResult<SubscriptionExpanded>)
              .data
              .is_currently_active ==
          true;

  bool get hasGracePeriodSubscription =>
      _result != null &&
      _result is ApiDataResult<SubscriptionExpanded> &&
      (_result as ApiDataResult<SubscriptionExpanded>)
              .data
              .has_one_month_to_expiry ==
          true;

  bool get hasNoAciveSubscriptions =>
      _result != null &&
      _result is ApiDataResult<SubscriptionExpanded> &&
      (_result as ApiDataResult<SubscriptionExpanded>)
              .data
              .is_currently_active ==
          true;

  SubscriptionState _state = SubscriptionState.pending;
  SubscriptionState get state => _state;

  void _setSubscriptionState() {
    if (hasAciveSubscriptions && !hasGracePeriodSubscription) {
      _state = SubscriptionState.active;
    } else if (hasAciveSubscriptions && hasGracePeriodSubscription) {
      _state = SubscriptionState.grace;
    } else if (hasNoAciveSubscriptions) {
      _state = SubscriptionState.inactive;
    }
    notifyListeners();

    return;
  }

  Future<void> notifyIfInGracePeriod() async {
    if (_state == SubscriptionState.grace) {
      final _auth = context.read<PxAuth>();
      final _l = context.read<PxLocale>();
      final _fcm = context.read<PxFirebaseNotifications>();
      final _sub = (_result as ApiDataResult<SubscriptionExpanded>).data;
      if (_result != null) {
        final _expDate = DateFormat(
          'dd / MM / yyyy',
          _l.lang,
        ).format(_sub.end_date_parsed);
        final ClientNotification _n = ClientNotification(
          client_token: '${_auth.user?.fcm_token}',
          message_title: _l.isEnglish
              ? """
Subscription Expiry Notice
"""
              : """
تنبيه انتهاء الاشتراك
""",
          message_body: _l.isEnglish
              ? """
Your Application Subscription Is About To Expire.
Expiry Date : $_expDate.
Make Sure To Renew Your Subscription Before This Date To Avoid Service Interruption.
"""
              : """
سينتهي اشتراكك في التطبيق قريبًا.
تاريخ انتهاء الاشتراك : $_expDate
تأكد من تجديد اشتراكك قبل هذا التاريخ لتجنب انقطاع الخدمة.
""",
          server_url: '${_auth.organization?.pb_endpoint}',
        );
        await _fcm.sendFcmNotification(_n);
      }
    }
  }
}

enum SubscriptionState {
  pending,
  active,
  inactive,
  grace,
}
