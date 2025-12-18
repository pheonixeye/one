// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:one/models/app_constants/account_type.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/speciality.dart';

class DtoCreateDoctorAccount extends Equatable {
  final String email;
  final String password;
  final String name_en;
  final String name_ar;
  final String phone;
  final String passwordConfirm;
  final Speciality speciality;
  final AccountType accountType;
  final bool emailVisibility;
  final AppPermission appPermission;

  const DtoCreateDoctorAccount({
    required this.email,
    required this.password,
    required this.name_en,
    required this.name_ar,
    required this.phone,
    required this.passwordConfirm,
    required this.speciality,
    required this.accountType,
    this.emailVisibility = true,
    required this.appPermission,
  });

  DtoCreateDoctorAccount copyWith({
    String? email,
    String? password,
    String? name_en,
    String? name_ar,
    String? phone,
    String? passwordConfirm,
    Speciality? speciality,
    AccountType? accountType,
    AppPermission? appPermission,
  }) {
    return DtoCreateDoctorAccount(
      email: email ?? this.email,
      password: password ?? this.password,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      phone: phone ?? this.phone,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      speciality: speciality ?? this.speciality,
      accountType: accountType ?? this.accountType,
      appPermission: appPermission ?? this.appPermission,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'emailVisibility': emailVisibility,
      // 'speciality_id': speciality.id,
      'account_type_id': accountType.id,
      'app_permissions_ids': [appPermission.id],
    };
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    email,
    password,
    passwordConfirm,
    name_en,
    name_ar,
    phone,
    speciality,
    accountType,
    emailVisibility,
    appPermission,
  ];
}
