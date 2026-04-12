import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/fcm_notifications_api.dart';
import 'package:one/models/notifications/client_notification.dart';
import 'package:one/models/notifications/in_app_notification.dart';
import 'package:one/providers/px_overlay.dart';
import 'package:one/widgets/notification_overlay.dart';
import 'package:uuid/uuid.dart';

class PxFirebaseNotifications extends ChangeNotifier {
  PxFirebaseNotifications({
    required this.context,
    required this.api,
  }) {
    initializeMessaging();
  }

  final BuildContext context;
  final FcmNotificationsApi api;

  static String? _fcmToken;
  String? get fcmToken => _fcmToken;

  static NotificationSettings? _settings;

  static AuthorizationStatus? _authorizationStatus;
  AuthorizationStatus? get authorizationStatus => _authorizationStatus;

  bool get isAuthorized =>
      _authorizationStatus == AuthorizationStatus.authorized;

  Future<void> initializeMessaging() async {
    if (await _requestPermission()) {
      await _getFcmToken();
      _handleForegroundMessage();
    }
  }

  Future<bool> _requestPermission() async {
    _settings = await FirebaseMessaging.instance.requestPermission(
      providesAppNotificationSettings: true,
      criticalAlert: true,
    );

    if (_settings != null) {
      _authorizationStatus = _settings!.authorizationStatus;
    }

    notifyListeners();

    final _isAuthorized = authorizationStatus == AuthorizationStatus.authorized;

    if (_isAuthorized == false && context.mounted) {
      final _id = Uuid().v4();

      final _notificationOverlayWidget = NotificationOverlayCard(
        key: ValueKey(_id),
        notification: InAppNotification(
          //TODO: allow for localization
          id: _id,
          title: 'Notifications Not Permitted',
          message:
              'You Can Toggle The Notification Permission In The Application Settings To Recieve Push Notifications.',
        ),
      );
      PxOverlay.toggleOverlay(
        id: _id,
        child: _notificationOverlayWidget,
      );
    }

    return _isAuthorized;
  }

  Future<String?> _getFcmToken() async {
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey: const String.fromEnvironment('VAPID_KEY'),
      );
      notifyListeners();
      return _fcmToken;
    } catch (e) {
      return null;
    }
  }

  Future<String?> get getFcmToken async => _fcmToken ?? await _getFcmToken();

  void _handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        final notification = message.notification;

        PxOverlay.toggleOverlay(
          id: '${message.messageId}',
          child: NotificationOverlayCard(
            key: ValueKey(message.messageId),
            notification: InAppNotification(
              id: message.messageId,
              title: notification?.title,
              message: notification?.body,
            ),
          ),
        );
        //todo: Save notification to pb => deferred
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        final notification = message.notification;

        PxOverlay.toggleOverlay(
          id: '${message.messageId}',
          child: NotificationOverlayCard(
            key: ValueKey(message.messageId),
            notification: InAppNotification(
              id: message.messageId,
              title: notification?.title,
              message: notification?.body,
            ),
          ),
        );
        //todo: Save notification to pb => deferred
      }
    });
  }

  Future<void> sendFcmNotification(ClientNotification n) async {
    await api.sendFcmNotification(n);
  }
}

extension TxAuthorizationStatus on AuthorizationStatus {
  String authorizationStatusTr(bool isEnglish) {
    return switch (this) {
      AuthorizationStatus.authorized => isEnglish ? 'Authorized' : 'مسموح',
      AuthorizationStatus.denied => isEnglish ? 'Denied' : 'غير مسموح',
      AuthorizationStatus.notDetermined =>
        isEnglish ? 'Not Determined' : 'غير محدد',
      AuthorizationStatus.provisional => isEnglish ? 'Provisional' : 'اولي',
    };
  }
}
