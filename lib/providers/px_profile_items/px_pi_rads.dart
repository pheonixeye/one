import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/profile_items_api/pi_rads_api.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/models/doctor_items/pi_rads.dart';

class PxPiRads extends ChangeNotifier {
  final PiRadsApi api;

  PxPiRads({required this.api}) {
    fetchDoctorItems();
  }

  ApiResult<List<PiRad>>? _rads;
  ApiResult<List<PiRad>>? get rads => _rads;

  ApiResult<List<PiRad>>? _filteredRads;
  ApiResult<List<PiRad>>? get filteredRads => _filteredRads;

  Future<void> fetchDoctorItems() async {
    _rads = await api.fetchDoctorItems();
    _filteredRads = _rads;
    notifyListeners();
  }

  Future<void> retry() async => await fetchDoctorItems();

  Future<void> createItem(PiRad item) async {
    await api.createItem(item);
    await fetchDoctorItems();
  }

  Future<void> updateItem(String id, PiRad update) async {
    await api.updateItem(id, update);
    await fetchDoctorItems();
  }

  Future<void> deleteItem(String id) async {
    await api.deleteItem(id);
    await fetchDoctorItems();
  }

  void searchForItems(String item_name) {
    _filteredRads = ApiDataResult(
      data: (_rads as ApiDataResult<List<PiRad>>).data
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
    _filteredRads = _rads;
    notifyListeners();
  }
}
