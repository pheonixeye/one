import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/contracts_api.dart';
import 'package:one/models/contract.dart';
import 'package:one/providers/px_auth.dart';
import 'package:provider/provider.dart';

class PxContracts extends ChangeNotifier {
  final ContractsApi api;
  final BuildContext context;

  PxContracts({
    required this.api,
    required this.context,
  }) {
    _init();
  }

  ApiResult<List<Contract>>? _data;
  ApiResult<List<Contract>>? get data => _data;

  Future<void> _init() async {
    final _auth = context.read<PxAuth>();
    final _loggedInDocId = _auth.doc_id;
    final _isLoggedInUserSuperAdmin = _auth.isLoggedInUserSuperAdmin(context);
    if (_isLoggedInUserSuperAdmin) {
      _data = await api.fetchAllContracts();
    } else {
      _data = await api.fetchOneDoctorContracts(_loggedInDocId);
    }
    notifyListeners();
    filterContracts();
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

  List<Contract>? _filteredContracts;
  List<Contract>? get filteredContracts => _filteredContracts;

  void filterContracts({String? doc_id}) {
    if (_data != null) {
      final _contracts = (_data as ApiDataResult<List<Contract>>).data;
      if (doc_id == null) {
        _filteredContracts = _contracts;
      } else {
        _filteredContracts = _contracts
            .where((e) => e.doc_id == doc_id)
            .toList();
      }
      // print(_contracts);
      // print(_filteredContracts);
      notifyListeners();
    }
  }
}
