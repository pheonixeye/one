import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/visit_data_api.dart';
import 'package:one/models/doctor_items/pi_supply_item.dart';
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

  ///[FORMS]
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

  ///[DRUGS]
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

  ///[LABS]
  Future<void> addLabToVisitData(String lab_id) async {
    await api.addLabToVisitData(
      visit_data_id: (_result as ApiDataResult<VisitData>).data.id,
      lab_id: lab_id,
    );
    await _fetchVisitData();
  }

  Future<void> removeLabFromVisitData(String lab_id) async {
    await api.removeLabFromVisitData(
      visit_data_id: (_result as ApiDataResult<VisitData>).data.id,
      lab_id: lab_id,
    );
    await _fetchVisitData();
  }

  ///[RADS]
  Future<void> addRadToVisitData(String rad_id) async {
    await api.addRadToVisitData(
      visit_data_id: (_result as ApiDataResult<VisitData>).data.id,
      rad_id: rad_id,
    );
    await _fetchVisitData();
  }

  Future<void> removeRadFromVisitData(String rad_id) async {
    await api.removeRadFromVisitData(
      visit_data_id: (_result as ApiDataResult<VisitData>).data.id,
      rad_id: rad_id,
    );
    await _fetchVisitData();
  }

  ///[PROCEDURES]
  Future<void> addProcedureToVisitData(String proc_id) async {
    await api.addProcedureToVisitData(
      visit_data_id: (_result as ApiDataResult<VisitData>).data.id,
      proc_id: proc_id,
    );
    await _fetchVisitData();
  }

  Future<void> removeProcedureFromVisitData(String proc_id) async {
    await api.removeProcedureFromVisitData(
      visit_data_id: (_result as ApiDataResult<VisitData>).data.id,
      proc_id: proc_id,
    );
    await _fetchVisitData();
  }

  // Future<void> addToItemList(String item_id, ProfileSetupItem setupItem) async {
  //   await api.addToItemList(
  //     (_result as ApiDataResult<VisitData>).data,
  //     item_id,
  //     setupItem,
  //   );
  //   await _fetchVisitData();
  // }

  // Future<void> removeFromItemList(
  //   String item_id,
  //   ProfileSetupItem setupItem,
  // ) async {
  //   await api.removeFromItemList(
  //     (_result as ApiDataResult<VisitData>).data,
  //     item_id,
  //     setupItem,
  //   );
  //   await _fetchVisitData();
  // }

  ///[SUPPLIES]
  Future<void> addSupplyItemToVisitData(String supply_id) async {
    await api.addSupplyItemToVisitData(
      visit_data_id: (_result as ApiDataResult<VisitData>).data.id,
      supply_id: supply_id,
    );
    await _fetchVisitData();
  }

  Future<void> removeSupplyItemFromVisitData(String supply_id) async {
    await api.removeSupplyItemFromVisitData(
      visit_data_id: (_result as ApiDataResult<VisitData>).data.id,
      supply_id: supply_id,
    );
    await _fetchVisitData();
  }

  Future<void> updateSupplyItemQuantity(
    PiSupplyItem item,
    num new_quantity,
    num quantity_change,
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
