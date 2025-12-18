import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/clinic_inventory_api.dart';
import 'package:one/models/supplies/clinic_inventory_item.dart';

class PxClinicInventory extends ChangeNotifier {
  final ClinicInventoryApi api;
  PxClinicInventory({required this.api}) {
    _fetchClinicInventoryItems();
  }

  ApiResult<List<ClinicInventoryItem>>? _result;
  ApiResult<List<ClinicInventoryItem>>? get result => _result;

  Future<void> _fetchClinicInventoryItems() async {
    _result = await api.fetchClinicInventoryItems();
    notifyListeners();
  }

  Future<void> retry() async => await _fetchClinicInventoryItems();

  Future<void> addNewInventoryItems(List<ClinicInventoryItem> items) async {
    await api.addNewInventoryItems(items);
    await _fetchClinicInventoryItems();
  }
}
