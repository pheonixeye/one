import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/profile_items_api/pi_referrals_api.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/models/doctor_items/pi_referral.dart';

class PxPiReferrals extends ChangeNotifier {
  final PiReferralsApi api;

  PxPiReferrals({required this.api}) {
    fetchDoctorItems();
  }

  ApiResult<List<PiReferral>>? _referrals;
  ApiResult<List<PiReferral>>? get referrals => _referrals;

  ApiResult<List<PiReferral>>? _filteredReferrals;
  ApiResult<List<PiReferral>>? get filteredReferrals => _filteredReferrals;

  Future<void> fetchDoctorItems() async {
    _referrals = await api.fetchDoctorItems();
    _filteredReferrals = _referrals;
    notifyListeners();
  }

  Future<void> retry() async => await fetchDoctorItems();

  Future<void> createItem(PiReferral item) async {
    await api.createItem(item);
    await fetchDoctorItems();
  }

  Future<void> updateItem(String id, PiReferral update) async {
    await api.updateItem(id, update);
    await fetchDoctorItems();
  }

  Future<void> deleteItem(String id) async {
    await api.deleteItem(id);
    await fetchDoctorItems();
  }

  void searchForItems(String item_name) {
    _filteredReferrals = ApiDataResult(
      data: (_referrals as ApiDataResult<List<PiReferral>>).data
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
    _filteredReferrals = _referrals;
    notifyListeners();
  }
}
