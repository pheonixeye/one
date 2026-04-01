import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:one/models/whatsapp_models/org_visit_info.dart';

class WhatsappApi {
  const WhatsappApi();

  Future<bool> sendTextMessage(OrgVisitInfo info) async {
    const uri = String.fromEnvironment('WA_NOTIFICATION_URL');

    final _response = await http.post(
      Uri.parse(uri),
      body: jsonEncode(info.toJson()),
    );

    final _result = jsonDecode(_response.body) as Map<String, dynamic>;
    // print(_result);

    if (_result['code'] == 000) {
      return true;
    } else {
      // print(_result['data']);
      return false;
    }
  }
}
