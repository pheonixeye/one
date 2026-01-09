// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:one/models/doctor_items/_doctor_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';

class DoctorDocumentTypeItem extends DoctorItem implements Equatable {
  const DoctorDocumentTypeItem({
    required super.id,
    required super.doc_id,
    required super.name_en,
    required super.name_ar,
    super.item = ProfileSetupItem.documents,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'doc_id': doc_id,
    };
  }

  factory DoctorDocumentTypeItem.fromJson(Map<String, dynamic> map) {
    return DoctorDocumentTypeItem(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      doc_id: map['doc_id'] as String,
    );
  }

  @override
  List<Object> get props => [id, name_en, name_ar, doc_id];

  @override
  bool get stringify => true;
}
