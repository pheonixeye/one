import 'package:equatable/equatable.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';

class PiDocumentType extends Equatable {
  final String id;
  final String doc_id;
  final String name_en;
  final String name_ar;
  final bool is_allowed_on_portal;

  const PiDocumentType({
    required this.id,
    required this.doc_id,
    required this.name_en,
    required this.name_ar,
    required this.is_allowed_on_portal,
  });

  final ProfileSetupItem item = ProfileSetupItem.documents;

  PiDocumentType copyWith({
    String? id,
    String? doc_id,
    String? name_en,
    String? name_ar,
    bool? is_allowed_on_portal,
  }) {
    return PiDocumentType(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      is_allowed_on_portal: is_allowed_on_portal ?? this.is_allowed_on_portal,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'name_en': name_en,
      'name_ar': name_ar,
      'is_allowed_on_portal': is_allowed_on_portal,
    };
  }

  factory PiDocumentType.fromJson(Map<String, dynamic> map) {
    return PiDocumentType(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      is_allowed_on_portal: map['is_allowed_on_portal'] as bool,
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
      is_allowed_on_portal,
    ];
  }
}
