import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/user/user.dart';
import 'package:pocketbase/pocketbase.dart';

@PbBase()
class AssistantAccountsApi {
  const AssistantAccountsApi({required this.org_id});
  final String org_id;

  static const String collection = 'users';

  static const _expandList = ['account_type_id', 'app_permissions_ids'];

  static final _expand = _expandList.join(',');

  Future<ApiResult<User>> createAssistantAccount(
    User account,
    String password,
    String passwordConfirm,
  ) async {
    try {
      final result = await PocketbaseHelper.pbBase
          .collection(collection)
          .create(
            body: {
              ...account.toJson(),
              'verified': false,
              'emailVisibility': true,
              'password': password,
              'passwordConfirm': passwordConfirm,
              'account_type_id': account.account_type.id,
              'app_permissions_ids': account.app_permissions
                  .map((e) => e.id)
                  .toList(),
            },
            expand: _expand,
          );

      await PocketbaseHelper.pbBase
          .collection('organizations')
          .update(
            account.org_id,
            body: {
              'members+': result.id,
            },
          );

      final _account = User.fromRecordModel(result);

      return ApiDataResult(data: _account);
    } on ClientException catch (e) {
      return ApiErrorResult<User>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<User>>> fetchAssistantAccounts() async {
    try {
      final result = await PocketbaseHelper.pbBase
          .collection(collection)
          .getList(
            filter: "org_id = '$org_id'",
            expand: _expand,
          );

      // prettyPrint(result);

      final _accounts = result.items
          .map((e) => User.fromRecordModel(e))
          .toList();

      final _assistants = _accounts
          .where((e) => e.account_type.name_en != 'Doctor')
          .toList();

      return ApiDataResult<List<User>>(data: _assistants);
    } on ClientException catch (e) {
      return ApiErrorResult<List<User>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> addAccountPermission(
    String account_id,
    String permission_id,
  ) async {
    await PocketbaseHelper.pbBase
        .collection(collection)
        .update(account_id, body: {'app_permissions_ids+': permission_id});
  }

  Future<void> removeAccountPermission(
    String account_id,
    String permission_id,
  ) async {
    await PocketbaseHelper.pbBase
        .collection(collection)
        .update(account_id, body: {'app_permissions_ids-': permission_id});
  }

  // Future<void> deleteAccount(String account_id) async {
  //   await PocketbaseHelper.pb.collection(collection).delete(
  //         account_id,
  //       );
  // }

  Future<RecordModel?> toogleActivity(String user_id, bool is_active) async {
    final result = await PocketbaseHelper.pbBase
        .collection(collection)
        .update(user_id, body: {'is_active': is_active});

    return result;
  }

  Future<RecordModel?> updateAccountName(String user_id, String name) async {
    final result = await PocketbaseHelper.pbBase
        .collection(collection)
        .update(user_id, body: {'name': name});

    return result;
  }
}
