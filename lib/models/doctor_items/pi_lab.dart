import 'package:equatable/equatable.dart';

import 'package:one/models/doctor_items/profile_setup_item.dart';

class PiLab extends Equatable {
  final String id;
  final String doc_id;
  final String name_en;
  final String name_ar;
  final String special_instructions;

  const PiLab({
    required this.id,
    required this.doc_id,
    required this.name_en,
    required this.name_ar,
    required this.special_instructions,
  });
  static final ProfileSetupItem item = ProfileSetupItem.labs;

  PiLab copyWith({
    String? id,
    String? doc_id,
    String? name_en,
    String? name_ar,
    String? special_instructions,
  }) {
    return PiLab(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      special_instructions: special_instructions ?? this.special_instructions,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'name_en': name_en,
      'name_ar': name_ar,
      'special_instructions': special_instructions,
    };
  }

  factory PiLab.fromJson(Map<String, dynamic> map) {
    return PiLab(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      special_instructions: map['special_instructions'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      doc_id,
      name_en,
      name_ar,
      special_instructions,
    ];
  }
}
