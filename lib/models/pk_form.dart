import 'package:equatable/equatable.dart';

import 'package:one/models/pk_field.dart';
import 'package:pocketbase/pocketbase.dart';

class PkForm extends Equatable {
  final String id;
  final String doc_id;
  final String name_en;
  final String name_ar;
  final List<PkField> fields;

  const PkForm({
    required this.id,
    required this.doc_id,
    required this.name_en,
    required this.name_ar,
    required this.fields,
  });

  PkForm copyWith({
    String? id,
    String? doc_id,
    String? name_en,
    String? name_ar,
    List<PkField>? fields,
  }) {
    return PkForm(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      fields: fields ?? this.fields,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'name_en': name_en,
      'name_ar': name_ar,
      'fields': fields.map((x) => x.toJson()).toList(),
    };
  }

  factory PkForm.fromJson(Map<String, dynamic> map) {
    return PkForm(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      fields: List<PkField>.from(
        (map['fields'] as List<dynamic>).map<PkField>(
          (x) => PkField.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory PkForm.fromRecordModel(RecordModel record) {
    return PkForm(
      id: record.getStringValue('id'),
      doc_id: record.getStringValue('doc_id'),
      name_en: record.getStringValue('name_en'),
      name_ar: record.getStringValue('name_ar'),
      fields: record
          .getListValue<RecordModel>('expand.fields')
          .map((e) => PkField.fromJson(e.toJson()))
          .toList(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    id,
    doc_id,
    name_en,
    name_ar,
    fields,
  ];
}
