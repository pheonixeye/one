import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

enum PresetType {
  unknown,
  drug,
  lab,
  rad;

  factory PresetType.fromString(String value) {
    return switch (value) {
      'drug' => drug,
      'lab' => lab,
      'rad' => rad,
      _ => unknown,
    };
  }
}

class Preset extends Equatable {
  final String id;
  final String title;
  final String doc_id;
  final PresetType type;
  final dynamic preset;

  const Preset({
    required this.id,
    required this.title,
    required this.doc_id,
    required this.type,
    required this.preset,
  });

  Preset copyWith({
    String? id,
    String? doc_id,
    String? title,
    PresetType? type,
    dynamic preset,
  }) {
    return Preset(
      id: id ?? this.id,
      title: title ?? this.title,
      doc_id: doc_id ?? this.doc_id,
      type: type ?? this.type,
      preset: preset ?? this.preset,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'doc_id': doc_id,
      'type': type.name,
      'preset': preset,
    };
  }

  factory Preset.fromRecordModel(RecordModel record) {
    final typeValue = record.getStringValue('type');

    final type = PresetType.fromString(typeValue);

    final preset = switch (type) {
      PresetType.unknown => {},
      PresetType.drug => {...(record.get('preset') as Map)},
      PresetType.lab => [...record.getListValue<String>('preset')],
      PresetType.rad => [...record.getListValue<String>('preset')],
    };

    return Preset(
      id: record.getStringValue('id'),
      doc_id: record.getStringValue('doc_id'),
      title: record.getStringValue('title'),
      type: type,
      preset: preset,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, doc_id, type, preset];
}
