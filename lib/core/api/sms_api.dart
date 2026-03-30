// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:http/http.dart' as http;

class SmsApi {
  SmsApi({
    required this.sms,
    required this.phone,
  });

  final String sms;
  final String phone;

  Future<bool> sendSms() async {
    const uri = String.fromEnvironment('SMS_NOTIFICATION_URL');

    final _response = await http.post(
      Uri.parse(uri),

      body: jsonEncode({
        'phone': phone,
        'message': sms,
      }),
    );

    final _result = jsonDecode(_response.body) as Map<String, dynamic>;

    if (_result['message'] == 'success') {
      return true;
    }
    throw http.ClientException(_result['message']);
  }
}
