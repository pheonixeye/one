import 'package:equatable/equatable.dart';

class PatientFormFieldData extends Equatable {
  final String id;
  final String field_name;
  final String field_value;

  const PatientFormFieldData({
    required this.id,
    required this.field_name,
    required this.field_value,
  });

  PatientFormFieldData copyWith({
    String? id,
    String? field_name,
    String? field_value,
  }) {
    return PatientFormFieldData(
      id: id ?? this.id,
      field_name: field_name ?? this.field_name,
      field_value: field_value ?? this.field_value,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'field_name': field_name,
      'field_value': field_value,
    };
  }

  factory PatientFormFieldData.fromJson(Map<String, dynamic> map) {
    return PatientFormFieldData(
      id: map['id'] as String,
      field_name: map['field_name'] as String,
      field_value: map['field_value'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, field_name, field_value];
}
