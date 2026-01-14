import 'dart:convert';

import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/reciept_info.dart';
import 'package:hive_ce/hive.dart';
import 'package:pocketbase/pocketbase.dart';

@PbData()
class RecieptInfoApi {
  RecieptInfoApi() {
    _initHive();
  }

  static const _collection = 'reciept_info';

  static Box<String>? _box;

  Future<void> _initHive() async {
    _box ??= await Hive.openBox(_collection);
  }

  Future<ApiResult<List<RecieptInfo>>> fetchRecieptInfo() async {
    try {
      final _response = await PocketbaseHelper.pbData
          .collection(_collection)
          .getList(sort: '-created');

      final info = _response.items
          .map((e) => RecieptInfo.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<RecieptInfo>>(data: info);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> addRecieptInfo(RecieptInfo reciept_info) async {
    await PocketbaseHelper.pbData
        .collection(_collection)
        .create(body: reciept_info.toJson());
  }

  Future<void> deleteRecieptInfo(String id) async {
    await PocketbaseHelper.pbData.collection(_collection).delete(id);
  }

  Future<void> updateRecieptInfo(RecieptInfo reciept_info) async {
    await PocketbaseHelper.pbData
        .collection(_collection)
        .update(reciept_info.id, body: {...reciept_info.toJson()});
  }

  Future<void> markInfoAsDefaultForDevice(RecieptInfo info) async {
    if (_box != null) {
      await _box!.put(_collection, jsonEncode(info.toJson()));
    }
  }

  Future<RecieptInfo?> getDefaultRecieptInfoForDevice() async {
    if (_box != null) {
      final _result = _box!.get(_collection);
      if (_result != null) {
        final _decoded = json.decode(_result);
        final _info = RecieptInfo.fromJson(_decoded);
        return _info;
      }
    }
    return null;
  }
}
