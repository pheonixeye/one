import 'package:equatable/equatable.dart';
import 'package:one/models/app_constants/account_type.dart';
import 'package:pocketbase/pocketbase.dart';

class UserDto extends Equatable {
  final String id;
  final String email;
  final String name;
  final String account_type_id;
  final List<String> app_permissions_ids;

  const UserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.account_type_id,
    required this.app_permissions_ids,
  });

  UserDto copyWith({
    String? id,
    String? email,
    String? name,
    String? account_type_id,
    List<String>? app_permissions_ids,
  }) {
    return UserDto(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      account_type_id: account_type_id ?? this.account_type_id,
      app_permissions_ids: app_permissions_ids ?? this.app_permissions_ids,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'account_type_id': account_type_id,
      'app_permissions_ids': app_permissions_ids,
    };
  }

  factory UserDto.fromJson(Map<String, dynamic> map) {
    return UserDto(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      account_type_id: map['account_type_id'] as String,
      app_permissions_ids: (map['app_permissions_ids'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    id,
    email,
    name,
    account_type_id,
    app_permissions_ids,
  ];
}

class UserWithAccounttypeAndToken extends UserDto {
  final AccountType accountType;
  final String fcm_token;

  const UserWithAccounttypeAndToken({
    required super.id,
    required super.email,
    required super.name,
    required super.account_type_id,
    required super.app_permissions_ids,
    required this.accountType,
    required this.fcm_token,
  });

  factory UserWithAccounttypeAndToken.fromRecordModel(RecordModel record) {
    final accountType = AccountType.fromJson(
      record.get<RecordModel>('expand.account_type_id').toJson(),
    );
    return UserWithAccounttypeAndToken(
      id: record.getStringValue('id'),
      email: record.getStringValue('email'),
      name: record.getStringValue('name'),
      account_type_id: record.getStringValue('account_type_id'),
      app_permissions_ids: record.getListValue<String>('app_permissions_ids'),
      accountType: accountType,
      fcm_token: record.getStringValue('fcm_token'),
    );
  }
}
