import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String dob;
  final String email;

  const Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.dob,
    required this.email,
  });

  Patient copyWith({
    String? id,
    String? name,
    String? phone,
    String? dob,
    String? email,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'dob': dob,
      'email': email,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      dob: map['dob'] as String,
      email: map['email'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        name,
        phone,
        dob,
        email,
      ];
}
