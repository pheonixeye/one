import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/profile_items_api/pi_drugs_api.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/models/doctor_items/pi_drug.dart';

class PxPiDrugs extends ChangeNotifier {
  final PiDrugsApi api;

  PxPiDrugs({required this.api}) {
    fetchDoctorItems();
  }

  ApiResult<List<PiDrug>>? _drugs;
  ApiResult<List<PiDrug>>? get drugs => _drugs;

  ApiResult<List<PiDrug>>? _filteredDrugs;
  ApiResult<List<PiDrug>>? get filteredDrugs => _filteredDrugs;

  Future<void> fetchDoctorItems() async {
    _drugs = await api.fetchDoctorItems();
    _filteredDrugs = _drugs;
    notifyListeners();
  }

  Future<void> retry() async => await fetchDoctorItems();

  Future<void> createItem(PiDrug item) async {
    await api.createItem(item);
    await fetchDoctorItems();
  }

  Future<void> updateItem(String id, PiDrug update) async {
    await api.updateItem(id, update);
    await fetchDoctorItems();
  }

  Future<void> deleteItem(String id) async {
    await api.deleteItem(id);
    await fetchDoctorItems();
  }

  void searchForItems(String item_name) {
    _filteredDrugs = ApiDataResult(
      data: (_drugs as ApiDataResult<List<PiDrug>>).data
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
    _filteredDrugs = _drugs;
    notifyListeners();
  }
}
