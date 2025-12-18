import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/assistant_accounts_api.dart';
import 'package:one/models/user/user.dart';
import 'package:one/models/user/user_with_password.dart';
import 'package:flutter/material.dart';

class PxAssistantAccounts extends ChangeNotifier {
  final AssistantAccountsApi api;

  PxAssistantAccounts({required this.api}) {
    _fetchAssistantAccounts();
  }

  ApiResult<List<User>>? _users;
  ApiResult<List<User>>? get users => _users;

  Future<void> _fetchAssistantAccounts() async {
    _users = await api.fetchAssistantAccounts();
    notifyListeners();
  }

  Future<void> retry() async => await _fetchAssistantAccounts();

  Future<void> addAssistantAccount(UserWithPassword value) async {
    await api.createAssistantAccount(
      value.user,
      value.password,
      value.confirmPassword,
    );

    await _fetchAssistantAccounts();
  }

  // Future<void> deleteAccount(String account_id) async {
  //   await api.deleteAccount(account_id);
  //   await _fetchAssistantAccounts();
  // }

  Future<void> addAccountPermission(
    String account_id,
    String permission_id,
  ) async {
    await api.addAccountPermission(account_id, permission_id);
    await _fetchAssistantAccounts();
  }

  Future<void> removeAccountPermission(
    String account_id,
    String permission_id,
  ) async {
    await api.removeAccountPermission(account_id, permission_id);
    await _fetchAssistantAccounts();
  }

  Future<void> toogleActivity(String user_id, bool is_active) async {
    await api.toogleActivity(user_id, is_active);
    await _fetchAssistantAccounts();
  }

  Future<void> updateAccountName(String user_id, String name) async {
    await api.updateAccountName(user_id, name);
    await _fetchAssistantAccounts();
  }
}
