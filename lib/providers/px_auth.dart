// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:one/core/api/auth/api_auth.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/functions/dprint.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/user/user.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:flutter/material.dart';
import 'package:one/providers/px_firebase_notifications.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

class PxAuth extends ChangeNotifier {
  final AuthApi api;
  final BuildContext context;

  PxAuth({
    required this.api,
    required this.context,
  });

  static RecordAuth? _auth;
  RecordAuth? get authModel => _auth;

  static User? _user;
  User? get user => _user;

  static Organization? _organization;
  Organization? get organization => _organization;

  Future<void> loginWithEmailAndPassword(
    String email,
    String password, [
    bool rememberMe = false,
  ]) async {
    try {
      String? _fcmToken = await context
          .read<PxFirebaseNotifications>()
          .getFcmToken;
      final result = await api.loginWithEmailAndPassword(
        email,
        password,
        rememberMe,
      );
      _auth = result;
      _user = User.fromRecordModel(_auth!.record);
      _organization = Organization.fromJson(
        result?.record.get<RecordModel>('expand.org_id').toJson() ?? {},
      );
      if (_organization != null) {
        PocketbaseHelper.initialize(_organization!.pb_endpoint);
      }
      if (_fcmToken != null) {
        await api.updateFcmToken(
          user_id: _user!.id,
          fcmToken: _fcmToken,
        );

        _user = _user?.copyWith(fcm_token: _fcmToken);
      }
      notifyListeners();
    } catch (e) {
      _auth = null;
      _user = null;
      _organization = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loginWithToken() async {
    try {
      String? _fcmToken = await context
          .read<PxFirebaseNotifications>()
          .getFcmToken;
      _auth = await api.loginWithToken();
      _user = User.fromRecordModel(_auth!.record);
      _organization = Organization.fromJson(
        _auth?.record.get<RecordModel>('expand.org_id').toJson() ?? {},
      );
      if (_organization != null) {
        PocketbaseHelper.initialize(_organization!.pb_endpoint);
      }
      // print(_fcmToken);
      if (_fcmToken != null) {
        await api.updateFcmToken(
          user_id: _user!.id,
          fcmToken: _fcmToken,
        );

        _user = _user?.copyWith(fcm_token: _fcmToken);
      }
      notifyListeners();
      dprint('token from api: ${_auth?.token.substring(20, 25)}');
    } catch (e) {
      _auth = null;
      _user = null;
      _organization = null;
      notifyListeners();
      rethrow;
    }
  }

  void logout() {
    try {
      api.logout();
      _auth = null;
      _user = null;
      _organization = null;
    } catch (e) {
      dprint(e.toString());
    }
  }

  bool get isLoggedIn => _auth != null;

  String get doc_id => _auth!.record.id;

  // static String get doc_id_static_getter => _auth!.record.id;

  bool get isUserNotDoctor =>
      _user?.account_type.name_en != 'Doctor'; //TODO: remove later

  bool isLoggedInUserSuperAdmin(BuildContext context) {
    final _appPermissions = context
        .read<PxAppConstants>()
        .constants
        ?.appPermission;

    final _superAdminPermission = _appPermissions?.firstWhere(
      (e) => e.name_en == 'SuperAdmin',
    );

    return _user != null &&
        _user!.app_permissions.contains(_superAdminPermission);
  }

  PermissionWithPermission isActionPermitted(
    PermissionEnum permission,
    BuildContext context,
  ) {
    final _appPermissions = context
        .read<PxAppConstants>()
        .constants
        ?.appPermission;

    final _adminPermission = context.read<PxAppConstants>().admin;

    final _userPermissions = _user?.app_permissions
        .map((e) => e.name_en)
        .toList();

    if (_user != null &&
        _appPermissions != null &&
        _userPermissions != null &&
        _userPermissions.contains(_adminPermission.name_en)) {
      return PermissionWithPermission(
        permission: _adminPermission,
        isAllowed: true,
      );
    }

    if (_user != null &&
        _appPermissions != null &&
        _userPermissions != null &&
        _userPermissions.contains(permission.name)) {
      return PermissionWithPermission(
        permission: _appPermissions.firstWhere(
          (p) => p.name_en == permission.name,
        ),
        isAllowed: true,
      );
    } else {
      return PermissionWithPermission(
        permission: _appPermissions!.firstWhere(
          (p) => p.name_en == permission.name,
        ),
        isAllowed: false,
      );
    }
  }

  Future<void> changePassword() async {
    if (_user != null) {
      await api.requestResetPassword(user!.email);
    }
  }
}

extension PatientDataUrl on PxAuth {
  String patientDataUrl(String patient_id) {
    final org_id = organization?.id;
    return '${const String.fromEnvironment('APP_URL')}/#/ar/patients_portal?org_id=$org_id&patient_id=$patient_id';
  }
}
