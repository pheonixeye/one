import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/presets_api.dart';
import 'package:one/models/preset.dart';

class PxPresets extends ChangeNotifier {
  final PresetsApi api;

  PxPresets({required this.api}) {
    _init();
  }

  Future<void> retry() async => await _init();

  ApiResult<List<Preset>>? _presets;
  ApiResult<List<Preset>>? get result => _presets;

  Future<void> _init() async {
    _presets = await api.fetchDoctorPresets();
    notifyListeners();
  }

  Future<void> createNewPreset(Preset preset) async {
    await api.createNewPreset(preset);
    await _init();
  }

  Future<void> deletePreset(String id) async {
    await api.deletePreset(id);
    await _init();
  }

  Future<void> updatePreset(String id, Map<String, dynamic> update) async {
    await api.updatePreset(id, update);
    await _init();
  }
}
