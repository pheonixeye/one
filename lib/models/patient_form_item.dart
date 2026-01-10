import 'package:equatable/equatable.dart';
import 'package:one/models/patient_form_field_data.dart';

class PatientFormItem extends Equatable {
  final String id;
  final String patient_id;
  final String doc_id;
  final String form_id;
  final List<PatientFormFieldData> form_data;

  const PatientFormItem({
    required this.id,
    required this.patient_id,
    required this.doc_id,
    required this.form_id,
    required this.form_data,
  });

  PatientFormItem copyWith({
    String? id,
    String? patient_id,
    String? doc_id,
    String? form_id,
    List<PatientFormFieldData>? form_data,
  }) {
    return PatientFormItem(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      patient_id: patient_id ?? this.patient_id,
      form_id: form_id ?? this.form_id,
      form_data: form_data ?? this.form_data,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'patient_id': patient_id,
      'form_id': form_id,
      'form_data': form_data.map((e) => e.toJson()).toList(),
    };
  }

  factory PatientFormItem.fromJson(Map<String, dynamic> map) {
    return PatientFormItem(
      id: map['id'] as String,
      patient_id: map['patient_id'] as String,
      doc_id: map['doc_id'] as String,
      form_id: map['form_id'] as String,
      form_data: (map['form_data'] as List<dynamic>)
          .map((e) => PatientFormFieldData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    id,
    patient_id,
    doc_id,
    form_id,
    form_data,
  ];
}
