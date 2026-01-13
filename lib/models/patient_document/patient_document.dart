import 'package:equatable/equatable.dart';

class PatientDocument extends Equatable {
  final String id;
  final String patient_id;
  final String related_visit_id;
  final String related_visit_data_id;
  final String document_type_id;
  final String document_url;
  final DateTime created;

  const PatientDocument({
    required this.id,
    required this.patient_id,
    required this.related_visit_id,
    required this.related_visit_data_id,
    required this.document_type_id,
    required this.document_url,
    required this.created,
  });

  PatientDocument copyWith({
    String? id,
    String? patient_id,
    String? related_visit_id,
    String? related_visit_date,
    String? related_visit_data_id,
    String? document_type_id,
    String? document_url,
    DateTime? created,
  }) {
    return PatientDocument(
      id: id ?? this.id,
      patient_id: patient_id ?? this.patient_id,
      related_visit_id: related_visit_id ?? this.related_visit_id,
      related_visit_data_id:
          related_visit_data_id ?? this.related_visit_data_id,
      document_type_id: document_type_id ?? this.document_type_id,
      document_url: document_url ?? this.document_url,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'patient_id': patient_id,
      'related_visit_id': related_visit_id,
      'related_visit_data_id': related_visit_data_id,
      'document_type_id': document_type_id,
      'document_url': document_url,
      'created': created,
    };
  }

  factory PatientDocument.fromJson(Map<String, dynamic> map) {
    return PatientDocument(
      id: map['id'] as String,
      patient_id: map['patient_id'] as String,
      related_visit_id: map['related_visit_id'] as String,
      related_visit_data_id: map['related_visit_data_id'] as String,
      document_type_id: map['document_type_id'] as String,
      document_url: map['document_url'] as String,
      created: map['created'] as DateTime,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      patient_id,
      related_visit_id,
      related_visit_data_id,
      document_type_id,
      document_url,
      created,
    ];
  }
}
