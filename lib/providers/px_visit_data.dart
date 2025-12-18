import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/visit_data_api.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/models/visit_data/visit_form_item.dart';

class PxVisitData extends ChangeNotifier {
  final VisitDataApi api;

  PxVisitData({required this.api}) {
    _fetchVisitData();
  }

  ApiResult<VisitData>? _result;
  ApiResult<VisitData>? get result => _result;

  Future<void> retry() async => await _fetchVisitData();

  Future<void> _fetchVisitData() async {
    _result = await api.fetchVisitData();
    // _subscribe();
    notifyListeners();
  }

  Future<void> attachForm(VisitFormItem form_data) async {
    await api.attachForm((_result as ApiDataResult<VisitData>).data, form_data);
    await _fetchVisitData();
  }

  Future<void> detachForm(VisitFormItem form_data) async {
    await api.detachForm((_result as ApiDataResult<VisitData>).data, form_data);
    await _fetchVisitData();
  }

  Future<void> updateFormData(VisitFormItem form_data) async {
    await api.updateFormData(
      (_result as ApiDataResult<VisitData>).data,
      form_data,
    );
    await _fetchVisitData();
  }

  Future<void> addDrugsToVisit(List<String> drugs_ids) async {
    await api.addDrugsToVisit(
      (_result as ApiDataResult<VisitData>).data,
      drugs_ids,
    );
    await _fetchVisitData();
  }

  Future<void> removeDrugsFromVisit(List<String> drugs_ids) async {
    await api.removeDrugsFromVisit(
      (_result as ApiDataResult<VisitData>).data,
      drugs_ids,
    );
    await _fetchVisitData();
  }

  Future<void> updateDrugsListInVisit(List<String> drugs_ids) async {
    await api.updateDrugsListInVisit(
      (_result as ApiDataResult<VisitData>).data,
      drugs_ids,
    );
    await _fetchVisitData();
  }

  Future<void> setDrugDose(String drug_id, String drug_dose) async {
    await api.setDrugDose(
      (_result as ApiDataResult<VisitData>).data,
      drug_id,
      drug_dose,
    );
    await _fetchVisitData();
  }

  Future<void> addToItemList(String item_id, ProfileSetupItem setupItem) async {
    await api.addToItemList(
      (_result as ApiDataResult<VisitData>).data,
      item_id,
      setupItem,
    );
    await _fetchVisitData();
  }

  Future<void> removeFromItemList(
    String item_id,
    ProfileSetupItem setupItem,
  ) async {
    await api.removeFromItemList(
      (_result as ApiDataResult<VisitData>).data,
      item_id,
      setupItem,
    );
    await _fetchVisitData();
  }

  Future<void> updateSupplyItemQuantity(
    DoctorSupplyItem item,
    double new_quantity,
    double quantity_change,
  ) async {
    await api.updateSupplyItemQuantity(
      (_result as ApiDataResult<VisitData>).data,
      item,
      new_quantity,
      quantity_change,
    );
    await _fetchVisitData();
  }
}
