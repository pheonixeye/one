import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/supply_movement_api.dart';
import 'package:one/models/supplies/supply_movement.dart';
import 'package:one/models/supplies/supply_movement_dto.dart';

class PxSupplyMovements extends ChangeNotifier {
  final SupplyMovementApi api;
  PxSupplyMovements({required this.api}) {
    _fetchSupplyMovements();
  }

  final _now = DateTime.now();

  ApiResult<List<SupplyMovement>>? _result;
  ApiResult<List<SupplyMovement>>? get result => _result;

  late DateTime _from = DateTime(_now.year, _now.month, 1);
  DateTime get from => _from;

  late DateTime _to = DateTime(_now.year, _now.month + 1, 1);
  DateTime get to => _to;

  Future<void> retry() async => await _fetchSupplyMovements();

  Future<void> _fetchSupplyMovements() async {
    _result = await api.fetchSupplyMovements(from: _from, to: _to);
    notifyListeners();
  }

  Future<void> changeDate({
    required DateTime from,
    required DateTime to,
  }) async {
    _from = from;
    _to = to;
    notifyListeners();
    await _fetchSupplyMovements();
  }

  Future<void> addSupplyMovements(List<SupplyMovementDto?> dtos) async {
    await api.addSupplyMovements(dtos);
    await _fetchSupplyMovements();
  }
}
