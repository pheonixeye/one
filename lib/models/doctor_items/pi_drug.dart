import 'package:equatable/equatable.dart';

import 'package:one/models/doctor_items/profile_setup_item.dart';

class PiDrug extends Equatable {
  final String id;
  final String doc_id;
  final String name_en;
  final String name_ar;
  final double concentration;
  final String unit;
  final String form;
  final List<String> default_doses;

  const PiDrug({
    required this.id,
    required this.doc_id,
    required this.name_en,
    required this.name_ar,
    required this.concentration,
    required this.unit,
    required this.form,
    required this.default_doses,
  });
  static final ProfileSetupItem item = ProfileSetupItem.drugs;

  PiDrug copyWith({
    String? id,
    String? doc_id,
    String? name_en,
    String? name_ar,
    double? concentration,
    String? unit,
    String? form,
    List<String>? default_doses,
  }) {
    return PiDrug(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      concentration: concentration ?? this.concentration,
      unit: unit ?? this.unit,
      form: form ?? this.form,
      default_doses: default_doses ?? this.default_doses,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'name_en': name_en,
      'name_ar': name_ar,
      'concentration': concentration,
      'unit': unit,
      'form': form,
      'default_doses': default_doses,
    };
  }

  factory PiDrug.fromJson(Map<String, dynamic> map) {
    return PiDrug(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      concentration: map['concentration'] as double,
      unit: map['unit'] as String,
      form: map['form'] as String,
      default_doses: List<String>.from(
        (map['default_doses'] as List<dynamic>),
      ),
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
      concentration,
      unit,
      form,
      default_doses,
    ];
  }

  String get prescriptionNameEn => '$name_en $concentration $unit $form';

  String get prescriptionNameAr => '$name_ar ($unit $concentration)  $form';
}
