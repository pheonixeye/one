import 'dart:convert';

import 'package:http/http.dart' as http;

class KuttApi {
  const KuttApi(this.original);
  final String original;

  static const LINK_SHORTENED_SUCCESS_CODE = 201;

  static const _headers = {
    'X-API-KEY': String.fromEnvironment('KUTT_API_KEY'),
    'Content-Type': 'application/json',
    "access-control-allow-origin": "*",
    "access-control-allow-headers": "*",
  };

  Future<String> shortenLink() async {
    final _uri = Uri.parse(
      '${const String.fromEnvironment('KUTT_URL')}/api/v2/links',
    );
    final _request = await http.post(
      _uri,
      headers: _headers,
      body: jsonEncode({
        'target': original,
      }),
    );
    if (_request.statusCode == LINK_SHORTENED_SUCCESS_CODE) {
      final _resBody = jsonDecode(_request.body) as Map<String, dynamic>;
      return _resBody['link'] as String;
    } else {
      throw http.ClientException('Patient Link Generation Failed...');
    }
  }
}
