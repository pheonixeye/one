import 'package:equatable/equatable.dart';

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
