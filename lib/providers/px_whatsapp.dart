import 'package:one/models/whatsapp_models/whatsapp_image_request.dart';
import 'package:one/models/whatsapp_models/whatsapp_device.dart';
import 'package:one/models/whatsapp_models/whatsapp_login_result.dart';
import 'package:one/models/whatsapp_models/whatsapp_server_response.dart';
import 'package:one/models/whatsapp_models/whatsapp_text_request.dart';
import 'package:flutter/material.dart';

import 'package:one/core/api/wa_api.dart';

class PxWhatsapp extends ChangeNotifier {
  final WaApi api;

  PxWhatsapp({required this.api}) {
    reconnect();
    fetchConnectedDevices();
  }

  WhatsappServerResponse<WhatsappLoginResult?>? _serverResult;
  WhatsappServerResponse<WhatsappLoginResult?>? get serverResult =>
      _serverResult;

  WhatsappServerResponse<List<WhatsappDevice>>? _connectedDevices;
  WhatsappServerResponse<List<WhatsappDevice>>? get connectedDevices =>
      _connectedDevices;

  Future<void> login() async {
    _serverResult = await api.login();
    notifyListeners();
  }

  Future<void> fetchConnectedDevices() async {
    _connectedDevices = await api.fetchDevices();
    notifyListeners();
  }

  Future<void> reconnect() async {
    final _result = await api.reconnect();
    _serverResult = WhatsappServerResponse(
      code: _result.code,
      message: _result.message,
      results: null,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    await api.logout();
    await fetchConnectedDevices();
  }

  bool get isConnectedToServer =>
      _serverResult != null && _serverResult!.code == 'SUCCESS';

  bool get hasConnectedDevices =>
      _connectedDevices != null &&
      _connectedDevices!.results != null &&
      _connectedDevices!.results!.isNotEmpty;

  Future<void> sendMessage(WhatsappTextRequest textRequest) async {
    await api.sendMessage(textRequest);
  }

  Future<void> sendImage(WhatsappImageRequest imageRequest) async {
    await api.sendImage(imageRequest);
  }
}
