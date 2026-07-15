import 'package:flutter/material.dart';
import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/forms_api.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/models/pk_form.dart';
import 'package:one/models/pk_field.dart';
import 'package:one/providers/px_auth.dart';
import 'package:provider/provider.dart';

@PbData()
class PxForms extends ChangeNotifier {
  PxForms({
    required this.api,
    required this.context,
  }) {
    _fetchDoctorForms();
  }
  final FormsApi api;
  final BuildContext context;

  ApiResult<List<PkForm>>? _result;
  ApiResult<List<PkForm>>? get result => _result;

  Future<void> _fetchDoctorForms() async {
    final _auth = context.read<PxAuth>();
    _result = _auth.isUserNotDoctor
        ? await api.fetchAllForms()
        : await api.fetchDoctorForms();
    notifyListeners();
  }

  Future<void> retry() async => await _fetchDoctorForms();

  Future<void> createPcForm(PkForm form) async {
    await api.createPcForm(form);
    await _fetchDoctorForms();
  }

  Future<void> deletePcForm(String id) async {
    await api.deletePcForm(id);
    await _fetchDoctorForms();
  }

  Future<void> updatePcForm(PkForm form) async {
    await api.updatePcForm(form);
    await _fetchDoctorForms();
  }

  Future<void> addNewFieldToForm(PkField newField) async {
    await api.addNewFieldToForm(newField);
    await _fetchDoctorForms();
  }

  Future<void> removeFieldFromForm(PkField toRemove) async {
    await api.removeFieldFromForm(toRemove);
    await _fetchDoctorForms();
  }

  Future<void> updateFieldValue(PkField toUpdate) async {
    await api.updateFieldValue(toUpdate);
    await _fetchDoctorForms();
  }
}
