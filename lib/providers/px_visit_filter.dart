import 'package:one/models/visits/visit.dart';
import 'package:one/models/visits/visits_filter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/visit_filter_api.dart';

class PxVisitFilter extends ChangeNotifier {
  final VisitFilterApi api;

  PxVisitFilter({required this.api}) {
    _fetchConcisedVisitsOfDateRange();
  }

  ApiResult<VisitExpanded>? _expandedSingleVisit;
  ApiResult<VisitExpanded>? get expandedSingleVisit => _expandedSingleVisit;

  ApiResult<List<VisitExpanded>>? _concisedVisits;
  ApiResult<List<VisitExpanded>>? get concisedVisits => _concisedVisits;

  final List<VisitExpanded> _filteredConcisedVisits = [];
  List<VisitExpanded> get filteredConcisedVisits => _filteredConcisedVisits;

  final _now = DateTime.now();

  late DateTime _from = DateTime(_now.year, _now.month, 1);
  DateTime get from => _from;

  late DateTime _to = DateTime(_now.year, _now.month + 1, 1);
  DateTime get to => _to;

  String get formattedFrom => DateFormat('yyyy-MM-dd', 'en').format(from);
  String get formattedTo =>
      DateFormat('yyyy-MM-dd', 'en').format(to.copyWith(day: to.day + 1));

  Future<void> _fetchConcisedVisitsOfDateRange() async {
    _concisedVisits = await api.fetctVisitsOfDateRange(
      from: formattedFrom,
      to: formattedTo,
    );
    _filteredConcisedVisits.clear();
    notifyListeners();
    filterVisits(_filter, _filterId);
    // notifyListeners();
  }

  Future<void> retry() async => await _fetchConcisedVisitsOfDateRange();

  Future<void> changeDate({
    required DateTime from,
    required DateTime to,
  }) async {
    _from = from;
    _to = to;
    notifyListeners();
    await _fetchConcisedVisitsOfDateRange();
    // filterVisits(_filter, _filterId);
  }

  Future<void> fetchOneExpandedVisit(String visit_id) async {
    _expandedSingleVisit = await api.fetchOneExpandedVisit(visit_id);
    notifyListeners();
  }

  Future<void> nullifyExpandedVisit() async {
    _expandedSingleVisit = null;
    notifyListeners();
  }

  VisitsFilter _filter = VisitsFilter.no_filter;
  VisitsFilter get filter => _filter;

  String _filterId = '';
  String get filterId => _filterId;

  void _setVisitsfilter(VisitsFilter value, [String filterId = '']) {
    _filter = value;
    _filterId = filterId;
    notifyListeners();
  }

  List<VisitExpanded> _filterByDoctor(List<VisitExpanded> data, String doc_id) {
    return data.where((e) => e.doc_id == doc_id).toList();
  }

  List<VisitExpanded> _filterByClinic(
    List<VisitExpanded> data,
    String clinic_id,
  ) {
    return data.where((e) => e.clinic_id == clinic_id).toList();
  }

  void filterVisits(VisitsFilter value, String id) {
    _setVisitsfilter(value, id);
    _filteredConcisedVisits.clear();
    notifyListeners();
    final _data = (_concisedVisits as ApiDataResult<List<VisitExpanded>>).data;
    final _filtered = switch (_filter) {
      VisitsFilter.no_filter => _data,
      VisitsFilter.by_doctor => _filterByDoctor(_data, id),
      VisitsFilter.by_clinic => _filterByClinic(_data, id),
    };
    _filteredConcisedVisits.addAll(_filtered);
    notifyListeners();
  }
}
