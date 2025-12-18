import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/patient_previous_visits_api.dart';
import 'package:one/models/visits/_visit.dart';
import 'package:flutter/material.dart';

class PxPatientPreviousVisits extends ChangeNotifier {
  final PatientPreviousVisitsApi api;

  PxPatientPreviousVisits({required this.api}) {
    _init();
  }

  ApiResult<List<Visit>>? _data;
  ApiResult<List<Visit>>? get data => _data;

  int _page = 1;
  int get page => _page;

  final int _perPage = 10;

  Future<void> _init() async {
    _data = await api.fetchPatientVisits(page: page, perPage: _perPage);
    notifyListeners();
  }

  Future<void> retry() async => await _init();

  Future<void> nextPage() async {
    if ((_data as ApiDataResult<List<Visit>>).data.length < _perPage) {
      return;
    }
    _page++;
    notifyListeners();
    await _init();
  }

  Future<void> previousPage() async {
    if (_page <= 1) {
      return;
    }
    _page--;
    notifyListeners();
    await _init();
  }
}
