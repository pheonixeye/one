import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/profile_items_api/pi_api.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/doctor_items/pi_drug.dart';

class PiDrugsApi extends PiApi<PiDrug> {
  final String doc_id;

  PiDrugsApi({required this.doc_id});

  static const String collection = 'drugs';

  @override
  Future<void> createItem(item) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .create(
          body: item.toJson(),
        );
  }

  @override
  Future<void> deleteItem(String id) async {
    await PocketbaseHelper().pbData.collection(collection).delete(id);
  }

  @override
  Future<ApiResult<List<PiDrug>>> fetchDoctorItems() async {
    try {
      final _result = await PocketbaseHelper().pbData
          .collection(collection)
          .getList(
            perPage: 500,
            page: 1,
            filter: "doc_id = '$doc_id'",
          );

      final _items = _result.items
          .map((e) => PiDrug.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<PiDrug>>(data: _items);
    } catch (e) {
      return ApiErrorResult<List<PiDrug>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> updateItem(String id, update) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          id,
          body: update.toJson(),
        );
  }
}
