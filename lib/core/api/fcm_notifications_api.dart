import 'dart:convert';

import 'package:one/models/notifications/client_notification.dart';
import 'package:http/http.dart' as http;

class FcmNotificationsApi {
  const FcmNotificationsApi();

  //TODO: check CORS Issue in production

  Future<void> sendFcmNotification(ClientNotification n) async {
    final _uri = Uri.parse(
      const String.fromEnvironment('FCM_NOTIFICATION_URL'),
    );

    await http.post(
      _uri,
      body: jsonEncode(
        n.toJson(),
      ),
    );
  }
}
