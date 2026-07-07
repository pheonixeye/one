import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/profile_items_api/pi_labs_api.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/models/doctor_items/pi_lab.dart';

class PxPiLabs extends ChangeNotifier {
  final PiLabsApi api;

  PxPiLabs({required this.api}) {
    fetchDoctorItems();
  }

  ApiResult<List<PiLab>>? _labs;
  ApiResult<List<PiLab>>? get labs => _labs;

  ApiResult<List<PiLab>>? _filteredLabs;
  ApiResult<List<PiLab>>? get filteredLabs => _filteredLabs;

  Future<void> fetchDoctorItems() async {
    _labs = await api.fetchDoctorItems();
    _filteredLabs = _labs;
    notifyListeners();
  }

  Future<void> retry() async => await fetchDoctorItems();

  Future<void> createItem(PiLab item) async {
    await api.createItem(item);
    await fetchDoctorItems();
  }

  Future<void> updateItem(String id, PiLab update) async {
    await api.updateItem(id, update);
    await fetchDoctorItems();
  }

  Future<void> deleteItem(String id) async {
    await api.deleteItem(id);
    await fetchDoctorItems();
  }

  void searchForItems(String item_name) {
    _filteredLabs = ApiDataResult(
      data: (_labs as ApiDataResult<List<PiLab>>).data
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
    _filteredLabs = _labs;
    notifyListeners();
  }
}
