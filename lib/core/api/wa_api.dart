import 'dart:convert';
import 'package:one/functions/dprint.dart';
import 'package:one/models/whatsapp_models/whatsapp_image_request.dart';
import 'package:one/models/whatsapp_models/whatsapp_device.dart';
import 'package:one/models/whatsapp_models/whatsapp_login_result.dart';
import 'package:one/models/whatsapp_models/whatsapp_server_response.dart';
import 'package:one/models/whatsapp_models/whatsapp_text_request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class WaApi {
  const WaApi();
  //TODO: implement logger class
  //TODO: handle catch cases

  static const String _wa_url = String.fromEnvironment('WA_URL');
  static const String _wa_user = String.fromEnvironment('WA_USER');
  static const String _wa_password = String.fromEnvironment('WA_PASSWORD');

  static final _headers = {
    "Authorization":
        "Basic ${base64.encode('$_wa_user:$_wa_password'.codeUnits)}",
    "access-control-allow-origin": "*",
    "access-control-allow-headers": "*",
  };

  static final _imageHeaders = _headers
    ..addAll({'Content-Type': 'multipart/form-data'});

  Future<WhatsappServerResponse<WhatsappLoginResult?>> login() async {
    final _url = Uri.parse('$_wa_url/app/login');
    try {
      final _response = await http.get(_url, headers: _headers);

      final _result = jsonDecode(_response.body) as Map<String, dynamic>;

      dprint(_result);

      return WhatsappServerResponse<WhatsappLoginResult?>(
        code: _result['code'],
        message: _result['message'],
        results: _result['results'] == null
            ? null
            : WhatsappLoginResult(
                qr_duration: _result['results']['qr_duration'],
                qr_link: _result['results']['qr_link'],
              ),
      );
    } catch (e) {
      dprint(e);
      throw Exception(e.toString());
    }
  }

  Future<WhatsappServerResponse<List<WhatsappDevice>>> fetchDevices() async {
    final _url = Uri.parse('$_wa_url/app/devices');
    try {
      final _response = await http.get(_url, headers: _headers);

      final _result = jsonDecode(_response.body) as Map<String, dynamic>;

      dprint(_result);

      return WhatsappServerResponse<List<WhatsappDevice>>(
        code: _result['code'],
        message: _result['message'],
        results: _result['results'] == null
            ? null
            : (_result['results'] as List<dynamic>)
                  .map((e) => WhatsappDevice.fromJson(e))
                  .toList(),
      );
    } catch (e) {
      dprint(e);
      throw Exception(e.toString());
    }
  }

  Future<WhatsappServerResponse> reconnect() async {
    final _url = Uri.parse('$_wa_url/app/reconnect');
    try {
      final _response = await http.get(_url, headers: _headers);

      final _result = jsonDecode(_response.body) as Map<String, dynamic>;

      dprint(_result);

      return WhatsappServerResponse(
        code: _result['code'],
        message: _result['message'],
      );
    } catch (e) {
      dprint(e);
      throw Exception(e.toString());
    }
  }

  Future<WhatsappServerResponse> logout() async {
    final _url = Uri.parse('$_wa_url/app/logout');
    try {
      final _response = await http.get(_url, headers: _headers);

      final _result = jsonDecode(_response.body) as Map<String, dynamic>;

      dprint(_result);

      return WhatsappServerResponse(
        code: _result['code'],
        message: _result['message'],
      );
    } catch (e) {
      dprint(e);
      throw Exception(e.toString());
    }
  }

  Future<WhatsappServerResponse> sendMessage(
    WhatsappTextRequest textRequest,
  ) async {
    final _url = Uri.parse('$_wa_url/send/message');
    try {
      final _response = await http.post(
        _url,
        headers: _headers,
        body: textRequest.toJson(),
      );

      final _result = jsonDecode(_response.body) as Map<String, dynamic>;

      dprint(_result);

      return WhatsappServerResponse(
        code: _result['code'],
        message: _result['message'],
      );
    } catch (e) {
      dprint(e);
      throw Exception(e.toString());
    }
  }

  Future<WhatsappServerResponse> sendImage(
    WhatsappImageRequest imageRequest,
  ) async {
    final _url = Uri.parse('$_wa_url/send/image');
    try {
      final _request = http.MultipartRequest('POST', _url);

      final _formFields = _request.fields;

      imageRequest.toJson().entries.map((e) {
        _formFields[e.key] = e.value;
      }).toList();

      _request.headers.addAll({..._imageHeaders});

      _request.files.add(
        http.MultipartFile.fromBytes(
          'image', // Field name on the server
          imageRequest.image,
          filename: 'image.png',
          contentType: MediaType.parse('image/png'),
        ),
      );

      final _requestSend = await _request.send();

      final _result =
          jsonDecode(await _requestSend.stream.bytesToString())
              as Map<String, dynamic>;

      dprint(_result);

      return WhatsappServerResponse(
        code: _result['code'],
        message: _result['message'],
      );
    } catch (e) {
      dprint(e);
      throw Exception(e.toString());
    }
  }
}
