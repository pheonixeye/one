import 'package:equatable/equatable.dart';
import 'package:one/models/app_constants/account_type.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:pocketbase/pocketbase.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final bool verified;
  final bool is_active;
  final AccountType account_type;
  final List<AppPermission> app_permissions;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.verified,
    required this.is_active,
    required this.account_type,
    required this.app_permissions,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    bool? verified,
    bool? is_active,
    AccountType? account_type,
    List<AppPermission>? app_permissions,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      verified: verified ?? this.verified,
      is_active: is_active ?? this.is_active,
      account_type: account_type ?? this.account_type,
      app_permissions: app_permissions ?? this.app_permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'verified': verified,
      'is_active': is_active,
      'account_type': account_type.toJson(),
      'app_permissions': app_permissions.map((x) => x.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      verified: map['verified'] as bool,
      is_active: map['is_active'] as bool,
      account_type: AccountType.fromJson(
        map['account_type'] as Map<String, dynamic>,
      ),
      app_permissions: List<AppPermission>.from(
        (map['app_permissions'] as List<dynamic>).map<AppPermission>(
          (x) => AppPermission.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory User.fromRecordModel(RecordModel e) {
    return User(
      id: e.getStringValue('id'),
      email: e.getStringValue('email'),
      name: e.getStringValue('name'),
      verified: e.getBoolValue('verified'),
      is_active: e.getBoolValue('is_active'),
      account_type: AccountType.fromJson(
        e.get<RecordModel>('expand.account_type_id').toJson(),
      ),
      app_permissions: e
          .get<List<RecordModel>>('expand.app_permissions_ids')
          .map((x) => AppPermission.fromJson(x.toJson()))
          .toList(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    id,
    email,
    verified,
    account_type,
    app_permissions,
  ];
}
