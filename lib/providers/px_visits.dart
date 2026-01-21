import 'package:one/models/shift.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/visits_api.dart';
import 'package:one/models/visits/visit.dart';

class PxVisits extends ChangeNotifier {
  final VisitsApi api;

  PxVisits({required this.api}) {
    _fetchVisitsOfToday();
    fetchVisitsOfOneMonth();
  }

  ApiResult<List<VisitExpanded>>? _visits;
  ApiResult<List<VisitExpanded>>? get visits => _visits;

  static const int _page = 1;
  int get page => _page;

  //TODO: remove constant
  static const perPage = 100;

  Future<ApiResult<List<Visit>>> _fetchVisitsOfASpecificDate(
    DateTime visit_date,
  ) async {
    return await api.fetctVisitsOfASpecificDate(
      page: page,
      perPage: perPage,
      visit_date: visit_date,
    );
  }

  Future<void> _fetchVisitsOfToday() async {
    _visits = await api.fetctVisitsOfASpecificDate(
      page: page,
      perPage: perPage,
    );
    notifyListeners();
  }

  Future<void> retry() async => await _fetchVisitsOfToday();

  Future<void> addNewVisit(Visit dto) async {
    await api.addNewVisit(dto);
    await _fetchVisitsOfToday();
  }

  ///fetch visits of this date and clinic
  ///formulate [entry_number] && alert if that
  ///patient already has a visit in this clinic
  Future<List<VisitExpanded>> preCreateVisitRequest(
    DateTime visit_date,
    String clinic_id,
  ) async {
    toggleIsUpdating();
    final _result =
        (await _fetchVisitsOfASpecificDate(visit_date)
                as ApiDataResult<List<VisitExpanded>>)
            .data;
    final _clinicVisits = _result
        .where((e) => e.clinic_id == clinic_id)
        .toList();

    toggleIsUpdating();
    return _clinicVisits;
  }

  Map<Shift, int>? _visitsPerShift;
  Map<Shift, int>? get visitsPerShift => _visitsPerShift;

  Future<void> calculateVisitsPerClinicShift(
    String clinic_id,
    DateTime visit_date,
  ) async {
    toggleIsUpdating();
    final _visits =
        await _fetchVisitsOfASpecificDate(visit_date)
            as ApiDataResult<List<VisitExpanded>>;

    final _clinicVisits = _visits.data
        .where((visit) => visit.clinic_id == clinic_id)
        .toList();

    if (_clinicVisits.isEmpty) {
      //TODO
      _visitsPerShift = {};
      notifyListeners();
      toggleIsUpdating();
      return;
    }

    final _shifts = _clinicVisits.first.clinic.clinic_schedule
        .firstWhere((sch) => sch.intday == visit_date.weekday)
        .shifts
        .map((e) => Shift.fromScheduleShift(e))
        .toSet();

    _visitsPerShift = {};

    _shifts.map((e) {
      _visitsPerShift![e] = 0;
    }).toList();

    _clinicVisits.map((v) {
      final _shift = Shift.fromVisit(v);
      _visitsPerShift!.entries.map((entry) {
        if (entry.key == _shift) {
          _visitsPerShift![_shift] = _visitsPerShift![_shift]! + 1;
        }
      }).toList();
    }).toList();
    notifyListeners();
    toggleIsUpdating();
  }

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  void toggleIsUpdating() {
    _isUpdating = !_isUpdating;
    notifyListeners();
  }

  Future<void> updateVisit({
    required VisitExpanded visit,
    required String key,
    required dynamic value,
  }) async {
    await api.updateVisit(visit, key, value);
    await _fetchVisitsOfToday();
  }

  ApiResult<List<VisitExpanded>>? _monthlyVisits;
  ApiResult<List<VisitExpanded>>? get monthlyVisits => _monthlyVisits;

  DateTime _nowMonth = DateTime.now().copyWith(day: 1);
  DateTime get nowMonth => _nowMonth;

  Future<void> fetchVisitsOfOneMonth({int? month, int? year}) async {
    _nowMonth = _nowMonth.copyWith(month: month, year: year);
    notifyListeners();
    _monthlyVisits = await api.fetctVisitsOfOneMonth(
      month: _nowMonth.month,
      year: _nowMonth.year,
    );
    notifyListeners();
  }

  //todo
  Future<void> updateVisitScheduleShift({
    required String visit_id,
    required Shift shift,
  }) async {
    await api.updateVisitScheduleShift(
      visit_id: visit_id,
      shift: shift,
    );
    await _fetchVisitsOfToday();
  }
}
