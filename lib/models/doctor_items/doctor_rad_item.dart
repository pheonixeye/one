import 'package:equatable/equatable.dart';

import 'package:one/models/doctor_items/_doctor_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';

enum RadiologyType {
  x_ray(db_value: 'x_ray', type_en: 'X-Ray', type_ar: 'اشعة سينية'),
  ct(db_value: 'ct', type_en: 'CT', type_ar: 'اشعة مقطعية'),
  us(db_value: 'us', type_en: 'Ultra-Sound', type_ar: 'موجات صوتية'),
  mri(db_value: 'mri', type_en: 'MRI', type_ar: 'رنين مغناطيسي'),
  iso(db_value: 'iso', type_en: 'Isotope', type_ar: 'نظائر مشعة'),
  inter(db_value: 'inter', type_en: 'Interventional', type_ar: 'اشعة تداخلية'),
  other(db_value: 'other', type_en: 'Others', type_ar: 'اخري');

  final String db_value;
  final String type_en;
  final String type_ar;

  const RadiologyType({
    required this.db_value,
    required this.type_en,
    required this.type_ar,
  });

  factory RadiologyType.fromString(String? db_value) {
    return RadiologyType.values.firstWhere(
      (e) => e.name == db_value,
      orElse: () => RadiologyType.other,
    );
  }
}

class DoctorRadItem extends DoctorItem implements Equatable {
  final String special_instructions;
  final RadiologyType type;

  const DoctorRadItem({
    required super.id,
    required super.doc_id,
    required super.name_en,
    required super.name_ar,
    required this.type,
    required this.special_instructions,
    super.item = ProfileSetupItem.rads,
  });

  DoctorRadItem copyWith({
    String? id,
    String? doc_id,
    String? name_en,
    String? name_ar,
    String? special_instructions,
    RadiologyType? type,
  }) {
    return DoctorRadItem(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      special_instructions: special_instructions ?? this.special_instructions,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'name_en': name_en,
      'name_ar': name_ar,
      'special_instructions': special_instructions,
      'type': type.name.toString(),
    };
  }

  factory DoctorRadItem.fromJson(Map<String, dynamic> map) {
    return DoctorRadItem(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      special_instructions: map['special_instructions'] as String,
      type: RadiologyType.fromString(map['type'].toString()),
    );
  }

  @override
  List<Object?> get props => [
    id,
    doc_id,
    name_en,
    name_ar,
    type,
    special_instructions,
  ];

  @override
  bool get stringify => true;
}
