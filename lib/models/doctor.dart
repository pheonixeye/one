import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;
  final String phone;
  final String email;
  final String spec_en;
  final String spec_ar;
  const Doctor({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.phone,
    required this.email,
    required this.spec_en,
    required this.spec_ar,
  });

  Doctor copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    String? phone,
    String? email,
    String? spec_en,
    String? spec_ar,
  }) {
    return Doctor(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      spec_en: spec_en ?? this.spec_en,
      spec_ar: spec_ar ?? this.spec_ar,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'phone': phone,
      'email': email,
      'spec_en': spec_en,
      'spec_ar': spec_ar,
    };
  }

  factory Doctor.fromJson(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      spec_en: map['spec_en'] as String,
      spec_ar: map['spec_ar'] as String,
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
      spec_en,
      spec_ar,
    ];
  }
}
