// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/visits_api.dart';
import 'package:one/models/shift.dart';
import 'package:one/models/visits/visit.dart';

class PxVisitsPerClinicShift extends ChangeNotifier {
  PxVisitsPerClinicShift({required this.visit_date, required this.clinic_id}) {
    calculateVisitsPerClinicShift();
  }
  final DateTime visit_date;
  final String clinic_id;

  final _api = VisitsApi();

  Future<ApiResult<List<Visit>>> _fetchVisitsOfASpecificDate() async {
    return await _api.fetctVisitsOfASpecificDate(
      page: 1,
      perPage: 500,
      visit_date: visit_date,
    );
  }

  Map<Shift, int>? _visitsPerShift;
  Map<Shift, int>? get visitsPerShift => _visitsPerShift;

  Future<void> calculateVisitsPerClinicShift() async {
    final _visits =
        await _fetchVisitsOfASpecificDate() as ApiDataResult<List<Visit>>;

    final _clinicVisits = _visits.data
        .where((visit) => visit.clinic_id == clinic_id)
        .toList();

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
      final _shift = Shift.fromVisitSchedule(v.visitSchedule);
      _visitsPerShift!.entries.map((entry) {
        if (entry.key == _shift) {
          _visitsPerShift![_shift] = _visitsPerShift![_shift]! + 1;
        }
      }).toList();
    }).toList();
    notifyListeners();
  }
}
