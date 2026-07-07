import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/profile_items_api/pi_api.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/doctor_items/pi_document_type.dart';

class PiDocumentTypesApi extends PiApi<PiDocumentType> {
  final String doc_id;

  PiDocumentTypesApi({required this.doc_id});

  static const String collection = 'documents';

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
  Future<ApiResult<List<PiDocumentType>>> fetchDoctorItems() async {
    try {
      final _result = await PocketbaseHelper().pbData
          .collection(collection)
          .getList(
            perPage: 500,
            page: 1,
            filter: "doc_id = '$doc_id'",
          );

      final _items = _result.items
          .map((e) => PiDocumentType.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<PiDocumentType>>(data: _items);
    } catch (e) {
      return ApiErrorResult<List<PiDocumentType>>(
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
