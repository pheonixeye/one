import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

class PortalClinic extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;
  final String doc_name_en;
  final String doc_name_ar;
  final String spec_en;
  final String spec_ar;

  const PortalClinic({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.doc_name_en,
    required this.doc_name_ar,
    required this.spec_en,
    required this.spec_ar,
  });

  PortalClinic copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    String? doc_name_en,
    String? doc_name_ar,
    String? spec_en,
    String? spec_ar,
  }) {
    return PortalClinic(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      doc_name_en: doc_name_en ?? this.doc_name_en,
      doc_name_ar: doc_name_ar ?? this.doc_name_ar,
      spec_en: spec_en ?? this.spec_en,
      spec_ar: spec_ar ?? this.spec_ar,
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
      doc_name_en,
      doc_name_ar,
      spec_en,
      spec_ar,
    ];
  }

  factory PortalClinic.fromRecordModel(RecordModel record) {
    return PortalClinic(
      id: record.getStringValue('id'),
      name_en: record.getStringValue('name_en'),
      name_ar: record.getStringValue('name_ar'),
      doc_name_en: record.getStringValue('expand.doc_id.0.name_en'),
      doc_name_ar: record.getStringValue('expand.doc_id.0.name_ar'),
      spec_en: record.getStringValue('expand.doc_id.0.spec_en'),
      spec_ar: record.getStringValue('expand.doc_id.0.spec_ar'),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'doc_name_en': doc_name_en,
      'doc_name_ar': doc_name_ar,
      'spec_en': spec_en,
      'spec_ar': spec_ar,
    };
  }
}
