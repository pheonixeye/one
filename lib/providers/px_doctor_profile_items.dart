import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/doctor_profile_items_api.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/models/doctor_items/_doctor_item.dart';

class PxDoctorProfileItems<T extends DoctorItem> extends ChangeNotifier {
  final DoctorProfileItemsApi<T> api;

  PxDoctorProfileItems({required this.api}) {
    _fetchItems();
  }

  ApiResult<List<T>>? _data;
  ApiResult<List<T>>? get data => _data;

  ApiResult<List<T>>? _filteredData;
  ApiResult<List<T>>? get filteredData => _filteredData;

  Future<void> _fetchItems() async {
    _data = await api.fetchDoctorProfileItems();
    notifyListeners();
    _filteredData = _data;
    notifyListeners();
  }

  Future<void> retry() async => await _fetchItems();

  Future<void> addNewItem(Map<String, dynamic> itemJson) async {
    await api.createItem(itemJson);
    await _fetchItems();
  }

  Future<void> updateItem(Map<String, dynamic> item) async {
    await api.updateItem(item);
    await _fetchItems();
  }

  Future<void> deleteItem(DoctorItem item) async {
    await api.deleteItem(item);
    await _fetchItems();
  }

  void searchForItems(String item_name) {
    _filteredData = ApiDataResult(
      data: (_data as ApiDataResult<List<T>>).data
          .where(
            (e) => containsArabic(item_name)
                ? e.name_ar.toLowerCase().startsWith(item_name)
                : e.name_en.toLowerCase().startsWith(item_name),
          )
          .toList(),
    );
    notifyListeners();
  }

  void clearSearch() {
    _filteredData = _data;
    notifyListeners();
  }
}
