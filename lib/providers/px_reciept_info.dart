import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/reciept_info_api.dart';
import 'package:one/models/reciept_info.dart';
import 'package:flutter/material.dart';

class PxRecieptInfo extends ChangeNotifier {
  final RecieptInfoApi api;

  PxRecieptInfo({required this.api}) {
    _init();
    _getDefaultRecieptInfoForDevice();
  }

  ApiResult<List<RecieptInfo>>? _result;
  ApiResult<List<RecieptInfo>>? get result => _result;

  static RecieptInfo? _info;
  RecieptInfo? get info => _info;

  Future<void> _init() async {
    _result = await api.fetchRecieptInfo();
    notifyListeners();
  }

  Future<void> retry() async => await _init();

  //todo: add info to hive / fetch info from hive

  Future<void> addRecieptInfo(RecieptInfo info) async {
    await api.addRecieptInfo(info);
    await _init();
  }

  Future<void> deleteRecieptInfo(String id) async {
    await api.deleteRecieptInfo(id);
    await _init();
  }

  Future<void> updateRecieptInfo(RecieptInfo info) async {
    await api.updateRecieptInfo(info);
    await _init();
  }

  Future<void> markInfoAsDefaultForDevice(RecieptInfo info) async {
    await api.markInfoAsDefaultForDevice(info);
    await _getDefaultRecieptInfoForDevice();
  }

  Future<void> _getDefaultRecieptInfoForDevice() async {
    _info = await api.getDefaultRecieptInfoForDevice();
    notifyListeners();
  }
}
