import 'package:equatable/equatable.dart';

import 'package:one/models/speciality.dart';

class Doctor extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;
  final String phone;
  final String email;

  const Doctor({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.phone,
    required this.email,
  });

  Doctor copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    String? phone,
    Speciality? speciality,
    String? email,
  }) {
    return Doctor(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'phone': phone,
      'email': email,
    };
  }

  Map<String, dynamic> toPbRecordJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'phone': phone,
      'email': email,
    };
  }

  factory Doctor.fromJson(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name_en,
      name_ar,
      phone,
      email,
    ];
  }
}
