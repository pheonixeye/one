import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/profile_items_api/pi_supply_items_api.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/models/doctor_items/pi_supply_item.dart';

class PxPiSupplies extends ChangeNotifier {
  final PiSupplyItemsApi api;

  PxPiSupplies({required this.api}) {
    fetchDoctorItems();
  }

  ApiResult<List<PiSupplyItem>>? _supplyItems;
  ApiResult<List<PiSupplyItem>>? get supplyItems => _supplyItems;

  ApiResult<List<PiSupplyItem>>? _filteredSupplyItems;
  ApiResult<List<PiSupplyItem>>? get filteredSupplyItems =>
      _filteredSupplyItems;

  Future<void> fetchDoctorItems() async {
    _supplyItems = await api.fetchDoctorItems();
    _filteredSupplyItems = _supplyItems;
    notifyListeners();
  }

  Future<void> retry() async => await fetchDoctorItems();

  Future<void> createItem(PiSupplyItem item) async {
    await api.createItem(item);
    await fetchDoctorItems();
  }

  Future<void> updateItem(String id, PiSupplyItem update) async {
    await api.updateItem(id, update);
    await fetchDoctorItems();
  }

  Future<void> deleteItem(String id) async {
    await api.deleteItem(id);
    await fetchDoctorItems();
  }

  void searchForItems(String item_name) {
    _filteredSupplyItems = ApiDataResult(
      data: (_supplyItems as ApiDataResult<List<PiSupplyItem>>).data
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
    _filteredSupplyItems = _supplyItems;
    notifyListeners();
  }
}
