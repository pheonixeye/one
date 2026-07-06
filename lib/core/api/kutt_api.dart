import 'dart:convert';

import 'package:http/http.dart' as http;

class KuttApi {
  const KuttApi(this.original);
  final String original;

  static const LINK_SHORTENED_SUCCESS_CODE = 201;

  static const _headers = {
    'X-API-KEY': String.fromEnvironment('KUTT_API_KEY'),
    // 'Content-Type': 'application/json',
    // "access-control-allow-origin": "*",
    // "access-control-allow-headers": "*",
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
    final _response = jsonDecode(_request.body) as Map<String, dynamic>;

    if (_response['link'] != null) {
      return _response['link'];
    }
    return _response['error'];
  }
}
