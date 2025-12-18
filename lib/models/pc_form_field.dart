import 'package:equatable/equatable.dart';

import 'package:one/models/pc_form_field_types.dart';

class PcFormField extends Equatable {
  final String id;
  final String field_name;
  final PcFormFieldType field_type;
  final List<String> values;

  const PcFormField({
    required this.id,
    required this.field_name,
    required this.field_type,
    required this.values,
  });

  PcFormField copyWith({
    String? id,
    String? field_name,
    PcFormFieldType? field_type,
    List<String>? values,
  }) {
    return PcFormField(
      id: id ?? this.id,
      field_name: field_name ?? this.field_name,
      field_type: field_type ?? this.field_type,
      values: values ?? this.values,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'field_name': field_name,
      'field_type': field_type.name.toString(),
      'values': values,
    };
  }

  factory PcFormField.fromJson(Map<String, dynamic> map) {
    return PcFormField(
      id: map['id'] as String,
      field_name: map['field_name'] as String,
      field_type: PcFormFieldType.fromString(map['field_type'].toString()),
      values: List<String>.from((map['values'] as List<dynamic>)),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, field_name, field_type, values];
}
