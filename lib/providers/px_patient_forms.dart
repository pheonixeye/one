import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/patient_forms_api.dart';
import 'package:one/models/patient_form_field_data.dart';
import 'package:one/models/patient_form_item.dart';
import 'package:one/models/pk_form.dart';
import 'package:one/providers/px_auth.dart';
import 'package:provider/provider.dart';

class PxPatientForms extends ChangeNotifier {
  final PatientFormsApi api;
  final BuildContext context;

  PxPatientForms({
    required this.api,
    required this.context,
  }) {
    _fetchPatientForms();
  }

  ApiResult<List<PatientFormItem>>? _result;
  ApiResult<List<PatientFormItem>>? get result => _result;

  Future<void> _fetchPatientForms() async {
    final _auth = context.read<PxAuth>();
    _result = _auth.isUserNotDoctor
        ? await api.fetchAllPatientForms()
        : await api.fetchDoctorPatientForms();
    notifyListeners();
  }

  Future<void> retry() async => await _fetchPatientForms();

  Future<void> attachFormToPatient(PatientFormItem formItem) async {
    await api.attachFormToPatient(formItem);
    await _fetchPatientForms();
  }

  Future<void> detachFormFromPatient(PatientFormItem formItem) async {
    await api.detachFormFromPatient(formItem);
    await _fetchPatientForms();
  }

  Future<void> updatePatientFormFieldData(
    PatientFormItem formItem,
    PatientFormFieldData formData,
  ) async {
    await api.updatePatientFormFieldData(formItem, formData);
    await _fetchPatientForms();
  }

  PkForm? _pcForm;
  PkForm? get pcForm => _pcForm;

  PatientFormItem? _formItem;
  PatientFormItem? get formItem => _formItem;

  Future<void> _checkIfFormIsUpdated(
    PkForm? pcForm,
    PatientFormItem? formItem,
  ) async {
    await api.checkIfFormIsUpdated(formItem!, pcForm!);
    await _fetchPatientForms();
  }

  Future<void> selectForms(PkForm? pcForm, PatientFormItem? formItem) async {
    await _checkIfFormIsUpdated(pcForm, formItem);
    _pcForm = pcForm;
    _formItem = formItem;
    notifyListeners();
  }

  void nullifyForms() {
    _pcForm = null;
    _formItem = null;
    notifyListeners();
  }
}
