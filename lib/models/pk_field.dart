import 'package:equatable/equatable.dart';

import 'package:one/models/pk_field_types.dart';

class PkField extends Equatable {
  final String id;
  final String doc_id;
  final String form_id;
  final String field_name;
  final PkFieldType field_type;
  final List<String> values;

  const PkField({
    required this.id,
    required this.doc_id,
    required this.form_id,
    required this.field_name,
    required this.field_type,
    required this.values,
  });

  PkField copyWith({
    String? id,
    String? doc_id,
    String? form_id,
    String? field_name,
    PkFieldType? field_type,
    List<String>? values,
  }) {
    return PkField(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      form_id: form_id ?? this.form_id,
      field_name: field_name ?? this.field_name,
      field_type: field_type ?? this.field_type,
      values: values ?? this.values,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'form_id': form_id,
      'field_name': field_name,
      'field_type': field_type.name.toString(),
      'values': values,
    };
  }

  factory PkField.fromJson(Map<String, dynamic> map) {
    return PkField(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      form_id: map['form_id'] as String,
      field_name: map['field_name'] as String,
      field_type: PkFieldType.fromString(map['field_type'].toString()),
      values: List<String>.from((map['values'] as List<dynamic>)),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    id,
    doc_id,
    form_id,
    field_name,
    field_type,
    values,
  ];
}
