import 'package:one/models/user/user_with_password.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/auth/auth_exception.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/functions/dprint.dart';
import 'package:one/models/dto_create_doctor_account.dart';
import 'package:one/utils/shared_prefs.dart';

class AuthApi {
  const AuthApi();

  static const _expandList = ['account_type_id', 'app_permissions_ids'];

  static final _expand = _expandList.join(',');

  Future<RecordModel?> createAccount(DtoCreateDoctorAccount dto) async {
    try {
      final result = await PocketbaseHelper.pb
          .collection('users')
          .create(body: dto.toJson());

      await PocketbaseHelper.pb
          .collection('doctors')
          .create(
            body: {
              'id': result.id,
              'speciality_id': dto.speciality.id,
              'name_en': dto.name_en,
              'name_ar': dto.name_ar,
              'phone': dto.phone,
              'email': dto.email,
            },
          );

      await PocketbaseHelper.pb
          .collection('users')
          .requestVerification(result.getStringValue('email'));
      return result;
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }
  }

  Future<RecordModel> createDoctorAccount(
    UserWithPasswordAndDoctorAccount dto,
  ) async {
    late RecordModel _userCreateResult;
    try {
      _userCreateResult = await PocketbaseHelper.pb
          .collection('users')
          .create(
            body: {
              'name': dto.userWithPassword.user.name,
              'email': dto.userWithPassword.user.email,
              'password': dto.userWithPassword.password,
              'passwordConfirm': dto.userWithPassword.confirmPassword,
              'emailVisibility': true,
              'account_type_id': dto.userWithPassword.user.account_type.id,
              'app_permissions_ids': [
                ...dto.userWithPassword.user.app_permissions.map((e) => e.id),
              ],
              'is_active': dto.userWithPassword.user.is_active,
            },
            expand: _expand,
          );
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }
    try {
      await PocketbaseHelper.pb
          .collection('doctors')
          .create(
            body: {
              ...dto.doctor.copyWith(id: _userCreateResult.id).toPbRecordJson(),
            },
          );
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }

    try {
      await PocketbaseHelper.pb
          .collection('users')
          .requestVerification(_userCreateResult.getStringValue('email'));
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }

    return _userCreateResult;
  }

  //# normal login flow
  Future<RecordAuth?> loginWithEmailAndPassword(
    String email,
    String password, [
    bool rememberMe = false,
  ]) async {
    RecordAuth? _result;
    try {
      _result = await PocketbaseHelper.pb
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
    PocketbaseHelper.pb.authStore.save(_token!, null);
    try {
      result = await PocketbaseHelper.pb
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
      await PocketbaseHelper.pb.collection('users').requestPasswordReset(email);
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }
  }

  void logout() {
    PocketbaseHelper.pb.authStore.clear();
    asyncPrefs.remove('token');
  }

  Future<RecordModel?> toogleAccountActivation(
    String user_id,
    bool is_active,
  ) async {
    final result = await PocketbaseHelper.pb
        .collection('users')
        .update(user_id, body: {'is_active': is_active});

    return result;
  }
}
