import 'package:flutter/material.dart';
import 'package:one/core/api/forms_api.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/models/pc_form.dart';
import 'package:one/models/pc_form_field.dart';

class PxForms extends ChangeNotifier {
  PxForms({required this.api}) {
    _fetchDoctorForms();
  }
  final FormsApi api;

  static ApiResult<List<PcForm>>? _result;
  ApiResult<List<PcForm>>? get result => _result;

  Future<void> _fetchDoctorForms() async {
    _result = await api.fetchDoctorForms();
    notifyListeners();
  }

  Future<void> retry() async => await _fetchDoctorForms();

  Future<void> createPcForm(PcForm form) async {
    await api.createPcForm(form);
    await _fetchDoctorForms();
  }

  Future<void> deletePcForm(String id) async {
    await api.deletePcForm(id);
    await _fetchDoctorForms();
  }

  Future<void> updatePcForm(PcForm form) async {
    await api.updatePcForm(form);
    await _fetchDoctorForms();
  }

  Future<void> addNewFieldToForm(PcForm form, PcFormField newField) async {
    await api.addNewFieldToForm(form, newField);
    await _fetchDoctorForms();
  }

  Future<void> removeFieldFromForm(PcForm form, PcFormField toRemove) async {
    await api.removeFieldFromForm(form, toRemove);
    await _fetchDoctorForms();
  }

  Future<void> updateFieldValue(PcForm form, PcFormField toUpdate) async {
    await api.updateFieldValue(form, toUpdate);
    await _fetchDoctorForms();
  }
}
