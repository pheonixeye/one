import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/visit_filter_api.dart';
import 'package:flutter/material.dart';
import 'package:one/models/visits/visit.dart';

class PxOneVisit extends ChangeNotifier {
  PxOneVisit({required this.api, required this.visit_id}) {
    _init();
  }
  final VisitFilterApi api;
  final String visit_id;

  ApiResult<Visit>? _result;
  ApiResult<Visit>? get result => _result;

  Future<void> _init() async {
    _result = await api.fetchOneExpandedVisit(visit_id);
    notifyListeners();
  }

  Future<void> retry() async => await _init();
}
