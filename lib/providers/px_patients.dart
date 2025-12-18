import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/patients_api.dart';
import 'package:one/models/patient.dart';

class PxPatients extends ChangeNotifier {
  final PatientsApi api;

  PxPatients({required this.api}) {
    fetchPatients();
  }

  static ApiResult? _data;
  ApiResult? get data => _data;

  static int _page = 1;
  int get page => _page;

  static final int perPage = 10;

  Future<void> fetchPatients() async {
    _data = await api.fetchPatients(page: page, perPage: perPage);
    notifyListeners();
  }

  Future<void> nextPage() async {
    if (_data != null &&
        _data is ApiDataResult &&
        (_data as ApiDataResult<List<Patient>>).data.length < 10) {
      return;
    }
    _page++;
    notifyListeners();
    await fetchPatients();
  }

  Future<void> previousPage() async {
    if (_page <= 1) {
      return;
    }
    _page--;
    notifyListeners();
    await fetchPatients();
  }

  Future<void> createPatientProfile(Patient patient) async {
    await api.createPatientProfile(patient);
    await fetchPatients();
  }

  Future<void> editPatientBaseData(Patient patient) async {
    await api.editPatientBaseData(patient);
    await fetchPatients();
  }

  Future<void> searchPatientsByName(String query) async {
    _page = 1;
    notifyListeners();
    _data = await api.searchPatientByName(
      query: query,
      page: page,
      perPage: perPage,
    );
    notifyListeners();
  }

  Future<void> searchPatientsByPhone(String query) async {
    _page = 1;
    notifyListeners();
    _data = await api.searchPatientByPhone(query: query);
    notifyListeners();
  }

  Future<void> clearSearch() async {
    _page = 1;
    notifyListeners();
    await fetchPatients();
  }
}
