import 'package:equatable/equatable.dart';
import 'package:one/models/app_constants/document_type.dart';
import 'package:pocketbase/pocketbase.dart';

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
      'created': created.toIso8601String(),
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
      created: DateTime.parse(map['created'] as String),
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

class PatientDocumentWithDocumentType extends PatientDocument {
  const PatientDocumentWithDocumentType({
    required super.id,
    required super.patient_id,
    required super.related_visit_id,
    required super.related_visit_data_id,
    required super.document_type_id,
    required super.document_url,
    required super.created,
    required this.documentType,
  });

  final DocumentType documentType;

  factory PatientDocumentWithDocumentType.fromRecordModel(RecordModel record) {
    return PatientDocumentWithDocumentType(
      id: record.getStringValue('id'),
      patient_id: record.getStringValue('patient_id'),
      related_visit_id: record.getStringValue('related_visit_id'),
      related_visit_data_id: record.getStringValue('related_visit_data_id'),
      document_type_id: record.getStringValue('document_type_id'),
      document_url: record.getStringValue('document_url'),
      created: DateTime.parse(record.getStringValue('created')),
      documentType: DocumentType.fromJson(
        record.get<RecordModel>('expand.document_type_id').toJson(),
      ),
    );
  }
}
