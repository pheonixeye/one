import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/preset.dart';
import 'package:pocketbase/pocketbase.dart';

class PresetsApi {
  final String doc_id;

  PresetsApi({required this.doc_id});

  static const String collection = 'presets';

  Future<ApiResult<List<Preset>>> fetchDoctorPresets() async {
    try {
      final _result = await PocketbaseHelper().pbData
          .collection(collection)
          .getFullList(filter: 'doc_id = "$doc_id"');

      final _presets = _result.map((e) => Preset.fromRecordModel(e)).toList();

      return ApiDataResult<List<Preset>>(data: _presets);
    } on ClientException catch (e) {
      return ApiErrorResult<List<Preset>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<Preset>> createNewPreset(Preset preset) async {
    try {
      final _result = await PocketbaseHelper().pbData
          .collection(collection)
          .create(
            body: preset.toJson(),
          );

      final _preset = Preset.fromRecordModel(_result);

      return ApiDataResult<Preset>(data: _preset);
    } on ClientException catch (e) {
      return ApiErrorResult<Preset>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<bool> deletePreset(String id) async {
    try {
      await PocketbaseHelper().pbData.collection(collection).delete(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResult<Preset>> updatePreset(
    String id,
    Map<String, dynamic> update,
  ) async {
    try {
      final _result = await PocketbaseHelper().pbData
          .collection(collection)
          .update(
            id,
            body: update,
          );

      final _preset = Preset.fromRecordModel(_result);

      return ApiDataResult<Preset>(data: _preset);
    } on ClientException catch (e) {
      return ApiErrorResult<Preset>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
