// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:one/models/doctor_items/_doctor_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';

class DoctorLabItem extends DoctorItem implements Equatable {
  final String special_instructions;

  const DoctorLabItem({
    required super.id,
    required super.name_en,
    required super.name_ar,
    required this.special_instructions,
    super.item = ProfileSetupItem.labs,
  });

  DoctorLabItem copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    String? special_instructions,
  }) {
    return DoctorLabItem(
      id: id ?? this.id,
      special_instructions: special_instructions ?? this.special_instructions,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'special_instructions': special_instructions,
    };
  }

  factory DoctorLabItem.fromJson(Map<String, dynamic> map) {
    return DoctorLabItem(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      special_instructions: map['special_instructions'] as String,
    );
  }

  @override
  List<Object> get props => [id, name_en, name_ar, special_instructions];

  @override
  bool get stringify => true;
}
