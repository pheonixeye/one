import 'package:one/annotations/unused.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/models/doctor_items/doctor_doument_type.dart';
import 'package:one/models/doctor_items/doctor_drug_item.dart';
import 'package:one/models/doctor_items/_doctor_item.dart';
import 'package:one/models/doctor_items/doctor_lab_item.dart';
import 'package:one/models/doctor_items/doctor_procedure_item.dart';
import 'package:one/models/doctor_items/doctor_rad_item.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';

class DoctorProfileItemsApi<T extends DoctorItem> {
  DoctorProfileItemsApi({
    required this.item,
    required this.doc_id,
  });

  final ProfileSetupItem item;
  final String doc_id;

  late final String collection = item.name;

  Future<ApiResult<List<T>>> fetchDoctorProfileItems() async {
    try {
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .getList(
            perPage: 500,
            page: 1,
            filter: "doc_id = '$doc_id'",
          );

      final _items = _result.items
          .map<T>(
            (e) => switch (item) {
              ProfileSetupItem.drugs =>
                DoctorDrugItem.fromJson(e.toJson()) as T,
              ProfileSetupItem.labs => DoctorLabItem.fromJson(e.toJson()) as T,
              ProfileSetupItem.rads => DoctorRadItem.fromJson(e.toJson()) as T,
              ProfileSetupItem.procedures =>
                DoctorProcedureItem.fromJson(e.toJson()) as T,
              ProfileSetupItem.supplies =>
                DoctorSupplyItem.fromJson(e.toJson()) as T,
              ProfileSetupItem.documents =>
                DoctorDocumentTypeItem.fromJson(e.toJson()) as T,
            },
          )
          .toList();

      return ApiDataResult<List<T>>(data: _items);
    } catch (e) {
      return ApiErrorResult<List<T>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> createItem(Map<String, dynamic> item) async {
    await PocketbaseHelper.pbData.collection(collection).create(body: item);
  }

  Future<void> updateItem(Map<String, dynamic> item) async {
    await PocketbaseHelper.pbData
        .collection(collection)
        .update(item['id'], body: item);
  }

  Future<void> deleteItem(DoctorItem item) async {
    await PocketbaseHelper.pbData.collection(collection).delete(item.id);
  }

  @Unused()
  Future<ApiResult<List<DoctorItem>>> searchForItems(String item_name) async {
    String filterField = containsArabic(item_name) ? 'name_ar' : 'name_en';
    try {
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .getList(
            perPage: 500,
            page: 1,
            filter: "$filterField = '$item_name'",
          );

      final _items = _result.items
          .map<DoctorItem>(
            (e) => switch (item) {
              ProfileSetupItem.drugs => DoctorDrugItem.fromJson(e.toJson()),
              ProfileSetupItem.labs => DoctorLabItem.fromJson(e.toJson()),
              ProfileSetupItem.rads => DoctorRadItem.fromJson(e.toJson()),
              ProfileSetupItem.procedures => DoctorProcedureItem.fromJson(
                e.toJson(),
              ),
              ProfileSetupItem.supplies => DoctorSupplyItem.fromJson(
                e.toJson(),
              ),
              ProfileSetupItem.documents => DoctorDocumentTypeItem.fromJson(
                e.toJson(),
              ),
            },
          )
          .toList();

      return ApiDataResult<List<DoctorItem>>(data: _items);
    } catch (e) {
      return ApiErrorResult<List<DoctorItem>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
