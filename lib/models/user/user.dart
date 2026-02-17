import 'package:equatable/equatable.dart';
import 'package:one/models/app_constants/account_type.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:pocketbase/pocketbase.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String org_id;
  final bool verified;
  final bool is_active;
  final AccountType account_type;
  final List<AppPermission> app_permissions;
  final String? fcm_token;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.org_id,
    required this.verified,
    required this.is_active,
    required this.account_type,
    required this.app_permissions,
    this.fcm_token,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? org_id,
    bool? verified,
    bool? is_active,
    AccountType? account_type,
    List<AppPermission>? app_permissions,
    String? fcm_token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      org_id: org_id ?? this.org_id,
      verified: verified ?? this.verified,
      is_active: is_active ?? this.is_active,
      account_type: account_type ?? this.account_type,
      app_permissions: app_permissions ?? this.app_permissions,
      fcm_token: fcm_token ?? this.fcm_token,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'org_id': org_id,
      'verified': verified,
      'is_active': is_active,
      'account_type': account_type.toJson(),
      'app_permissions': app_permissions.map((x) => x.toJson()).toList(),
      'fcm_token': fcm_token,
    };
  }

  factory User.fromRecordModel(RecordModel e) {
    return User(
      id: e.getStringValue('id'),
      email: e.getStringValue('email'),
      name: e.getStringValue('name'),
      org_id: e.getStringValue('org_id'),
      verified: e.getBoolValue('verified'),
      is_active: e.getBoolValue('is_active'),
      account_type: AccountType.fromJson(
        e.get<RecordModel>('expand.account_type_id').toJson(),
      ),
      app_permissions: e
          .get<List<RecordModel>>('expand.app_permissions_ids')
          .map((x) => AppPermission.fromJson(x.toJson()))
          .toList(),
      fcm_token: e.get<String?>('fcm_token'),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    org_id,
    verified,
    account_type,
    app_permissions,
    fcm_token,
  ];
}
