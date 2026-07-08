import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/profile_items_api/pi_procedures_api.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/models/doctor_items/pi_procedure.dart';

class PxPiProcedures extends ChangeNotifier {
  final PiProceduresApi api;

  PxPiProcedures({required this.api}) {
    fetchDoctorItems();
  }

  ApiResult<List<PiProcedure>>? _procedures;
  ApiResult<List<PiProcedure>>? get procedures => _procedures;

  ApiResult<List<PiProcedure>>? _filteredProcedures;
  ApiResult<List<PiProcedure>>? get filteredProcedures => _filteredProcedures;

  Future<void> fetchDoctorItems() async {
    _procedures = await api.fetchDoctorItems();
    _filteredProcedures = _procedures;
    notifyListeners();
  }

  Future<void> retry() async => await fetchDoctorItems();

  Future<void> createItem(PiProcedure item) async {
    await api.createItem(item);
    await fetchDoctorItems();
  }

  Future<void> updateItem(String id, PiProcedure update) async {
    await api.updateItem(id, update);
    await fetchDoctorItems();
  }

  Future<void> deleteItem(String id) async {
    await api.deleteItem(id);
    await fetchDoctorItems();
  }

  void searchForItems(String item_name) {
    _filteredProcedures = ApiDataResult(
      data: (_procedures as ApiDataResult<List<PiProcedure>>).data
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
    _filteredProcedures = _procedures;
    notifyListeners();
  }
}
