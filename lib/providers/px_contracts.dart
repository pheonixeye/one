import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/contracts_api.dart';
import 'package:one/models/contract.dart';

class PxContracts extends ChangeNotifier {
  final ContractsApi api;

  PxContracts({required this.api}) {
    _init();
  }

  ApiResult<List<Contract>>? _data;
  ApiResult<List<Contract>>? get data => _data;

  Future<void> _init() async {
    _data = await api.fetchAllContracts();
    notifyListeners();
  }

  Future<void> retry() async => await _init();

  Future<void> addNewContract(Contract contract) async {
    await api.addNewContract(contract);
    await _init();
  }

  Future<void> updateContract(String contract_id, Contract updated) async {
    await api.updateContract(contract_id, updated);
    await _init();
  }
}
