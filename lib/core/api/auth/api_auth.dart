import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/auth/auth_exception.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/functions/dprint.dart';
import 'package:one/utils/shared_prefs.dart';

class AuthApi {
  const AuthApi();

  static const _expandList = [
    'account_type_id',
    'app_permissions_ids',
    'org_id',
  ];

  static final _expand = _expandList.join(',');

  //# normal login flow
  Future<RecordAuth?> loginWithEmailAndPassword(
    String email,
    String password, [
    bool rememberMe = false,
  ]) async {
    RecordAuth? _result;
    try {
      _result = await PocketbaseHelper.pbBase
          .collection('users')
          .authWithPassword(email, password, expand: _expand);
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }

    if (rememberMe) {
      try {
        await asyncPrefs.setString('token', _result.token);
      } catch (e) {
        dprint("couldn't save token => ${e.toString()}");
      }
    }
    return _result;
  }

  //# remember me login flow
  Future<RecordAuth?> loginWithToken() async {
    RecordAuth? result;
    String? _token;
    try {
      _token = await asyncPrefs.getString('token');
    } catch (e) {
      dprint("couldn't fetch token => ${e.toString()}");
      return null;
    }
    PocketbaseHelper.pbBase.authStore.save(_token!, null);
    try {
      result = await PocketbaseHelper.pbBase
          .collection('users')
          .authRefresh(expand: _expand);
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }

    return result;
  }

  Future<void> requestResetPassword(String email) async {
    try {
      await PocketbaseHelper.pbBase
          .collection('users')
          .requestPasswordReset(email);
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }
  }

  void logout() {
    PocketbaseHelper.pbBase.authStore.clear();
    asyncPrefs.remove('token');
  }

  Future<RecordModel?> toogleAccountActivation(
    String user_id,
    bool is_active,
  ) async {
    final result = await PocketbaseHelper.pbBase
        .collection('users')
        .update(user_id, body: {'is_active': is_active});

    return result;
  }
}
