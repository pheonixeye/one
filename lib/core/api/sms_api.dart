// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class SmsApi {
  SmsApi({
    required this.sms,
    required this.phone,
  });

  final String sms;
  final String phone;

  static const String _baseUrl = String.fromEnvironment('BASE_URL');
  static const String _username = String.fromEnvironment('USERNAME');
  static const String _password = String.fromEnvironment('PASSWORD');
  static const String _sendername = String.fromEnvironment('SENDERNAME');

  Future<bool> sendSms() async {
    final _uri =
        // ignore: lines_longer_than_80_chars
        '$_baseUrl?username=$_username&password=$_password&sendername=$_sendername&mobiles=$phone&message=$sms';
    final _response = await http.get(
      Uri.parse(_uri),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': 'en-US',
      },
    );

    if (_response.statusCode != HttpStatus.ok) {
      return true;
    } else {
      final _result =
          (jsonDecode(_response.body) as List<dynamic>)[0]['type'] as String?;
      throw http.ClientException(_result ?? '');
    }
  }
}
