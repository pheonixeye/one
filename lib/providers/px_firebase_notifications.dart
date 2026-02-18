import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/fcm_notifications_api.dart';
import 'package:one/models/notifications/client_notification.dart';
import 'package:one/models/notifications/in_app_notification.dart';
import 'package:one/providers/px_overlay.dart';
import 'package:one/widgets/notification_overlay.dart';

final _messaging = FirebaseMessaging.instance;

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

  Future<void> initializeMessaging() async {
    await _messaging.setAutoInitEnabled(true);
    if (await _requestPermission()) {
      await _getFcmToken();
      _handleForegroundMessage();
    } else {
      return;
    }
  }

  Future<bool> _requestPermission() async {
    _settings = await _messaging.requestPermission(
      providesAppNotificationSettings: true,
      criticalAlert: true,
    );
    // print('${_settings?.authorizationStatus.name}');
    if (_settings != null) {
      _authorizationStatus = _settings!.authorizationStatus;
    }
    notifyListeners();
    return authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<String?> _getFcmToken() async {
    _fcmToken = await _messaging.getToken(
      vapidKey: const String.fromEnvironment('VAPID_KEY'),
    );
    // print(_fcmToken);
    notifyListeners();
    return _fcmToken;
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
  }

  Future<void> sendFcmNotification(ClientNotification n) async {
    await api.sendFcmNotification(n);
  }
}
