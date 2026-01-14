import 'package:flutter/material.dart';
import 'package:one/core/api/today_patient_progress_api.dart';
import 'package:one/models/visits/visit.dart';

class PxTodayPatientProgress extends ChangeNotifier {
  final TodayPatientProgressApi api;

  PxTodayPatientProgress({required this.api}) {
    _init();
    subscribe();
  }

  List<Visit> _visits = [];
  List<Visit> get visits => _visits;

  Future<void> _init() async {
    _visits = await api.fetchTodayVisits();
    notifyListeners();
  }

  Future<void> subscribe() async {
    await api.listenToVisitsCollectionStream((event) {
      switch (event.action) {
        case 'create':
          toggleUpdating();
          final _data = event.record;
          if (_data != null) {
            _visits.add(Visit.fromJson(_data.toJson()));
            _visits.sort(
              (b, a) =>
                  a.patient_entry_number.compareTo(b.patient_entry_number),
            );
            notifyListeners();
          }
          toggleUpdating();
          break;
        case 'update':
          final _data = event.record;
          if (_data != null) {
            toggleUpdating();
            final _visit = Visit.fromJson(_data.toJson());
            final _index = _visits.indexWhere((e) => e.id == _visit.id);
            _visits[_index] = _visit;
            _visits.sort(
              (b, a) =>
                  a.patient_entry_number.compareTo(b.patient_entry_number),
            );
            notifyListeners();
          }
          toggleUpdating();

          break;
        case 'delete':
          final _data = event.record;
          if (_data != null) {
            toggleUpdating();
            final _visit = Visit.fromJson(_data.toJson());
            final _index = _visits.indexWhere((e) => e.id == _visit.id);
            _visits.removeAt(_index);
            _visits.sort(
              (b, a) =>
                  a.patient_entry_number.compareTo(b.patient_entry_number),
            );
            notifyListeners();
          }
          toggleUpdating();
          break;
      }
    });
  }

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  void toggleUpdating() {
    _isUpdating = !_isUpdating;
    notifyListeners();
  }

  void unSubscribe() async {
    await api.listenToVisitsCollectionStream((_) {}).then((val) {
      val();
    });
  }

  @override
  void dispose() {
    unSubscribe();
    super.dispose();
  }
}
