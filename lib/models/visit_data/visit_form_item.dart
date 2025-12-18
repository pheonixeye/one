import 'package:equatable/equatable.dart';

class SingleFieldData extends Equatable {
  final String id;
  final String field_name;
  final String field_value;

  const SingleFieldData({
    required this.id,
    required this.field_name,
    required this.field_value,
  });

  SingleFieldData copyWith({
    String? id,
    String? field_name,
    String? field_value,
  }) {
    return SingleFieldData(
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

  factory SingleFieldData.fromJson(Map<String, dynamic> map) {
    return SingleFieldData(
      id: map['id'] as String,
      field_name: map['field_name'] as String,
      field_value: map['field_value'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        field_name,
        field_value,
      ];
}

class VisitFormItem extends Equatable {
  final String id;
  final String visit_id;
  final String patient_id;
  final String form_id;
  final List<SingleFieldData> form_data;

  const VisitFormItem({
    required this.id,
    required this.visit_id,
    required this.patient_id,
    required this.form_id,
    required this.form_data,
  });

  VisitFormItem copyWith({
    String? id,
    String? visit_id,
    String? patient_id,
    String? form_id,
    List<SingleFieldData>? form_data,
  }) {
    return VisitFormItem(
      id: id ?? this.id,
      visit_id: visit_id ?? this.visit_id,
      patient_id: patient_id ?? this.patient_id,
      form_id: form_id ?? this.form_id,
      form_data: form_data ?? this.form_data,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'visit_id': visit_id,
      'patient_id': patient_id,
      'form_id': form_id,
      'form_data': form_data.map((x) => x.toJson()).toList(),
    };
  }

  factory VisitFormItem.fromJson(Map<String, dynamic> map) {
    return VisitFormItem(
      id: map['id'] as String,
      visit_id: map['visit_id'] as String,
      patient_id: map['patient_id'] as String,
      form_id: map['form_id'] as String,
      form_data: List<SingleFieldData>.from(
        (map['form_data'] as List<dynamic>).map<SingleFieldData>(
          (x) => SingleFieldData.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        visit_id,
        form_id,
        form_data,
        patient_id,
      ];
}
