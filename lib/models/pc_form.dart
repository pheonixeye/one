import 'package:equatable/equatable.dart';

import 'package:one/models/pc_form_field.dart';

class PcForm extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;
  final List<PcFormField> form_fields;

  const PcForm({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.form_fields,
  });

  PcForm copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    List<PcFormField>? form_fields,
  }) {
    return PcForm(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      form_fields: form_fields ?? this.form_fields,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'form_fields': form_fields.map((x) => x.toJson()).toList(),
    };
  }

  factory PcForm.fromJson(Map<String, dynamic> map) {
    return PcForm(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      form_fields: List<PcFormField>.from(
        (map['form_fields'] as List<dynamic>).map<PcFormField>(
          (x) => PcFormField.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name_en, name_ar, form_fields];
}
