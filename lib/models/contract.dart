import 'package:equatable/equatable.dart';

class Contract extends Equatable {
  final String id;
  final String doc_id;
  final String name_en;
  final String name_ar;
  final bool is_active;
  final double patient_percent;
  final double company_percent;
  final double consultation_cost;
  final double followup_cost;

  const Contract({
    required this.id,
    required this.doc_id,
    required this.name_en,
    required this.name_ar,
    required this.is_active,
    required this.patient_percent,
    required this.company_percent,
    required this.consultation_cost,
    required this.followup_cost,
  });

  Contract copyWith({
    String? id,
    String? doc_id,
    String? name_en,
    String? name_ar,
    bool? is_active,
    double? patient_percent,
    double? company_percent,
    double? consultation_cost,
    double? followup_cost,
  }) {
    return Contract(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      is_active: is_active ?? this.is_active,
      patient_percent: patient_percent ?? this.patient_percent,
      company_percent: company_percent ?? this.company_percent,
      consultation_cost: consultation_cost ?? this.consultation_cost,
      followup_cost: followup_cost ?? this.followup_cost,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'name_en': name_en,
      'name_ar': name_ar,
      'is_active': is_active,
      'patient_percent': patient_percent,
      'company_percent': company_percent,
      'consultation_cost': consultation_cost,
      'followup_cost': followup_cost,
    };
  }

  factory Contract.fromJson(Map<String, dynamic> map) {
    return Contract(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      is_active: map['is_active'] as bool,
      patient_percent: map['patient_percent'] as double,
      company_percent: map['company_percent'] as double,
      consultation_cost: map['consultation_cost'] as double,
      followup_cost: map['followup_cost'] as double,
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
      is_active,
      patient_percent,
      company_percent,
      consultation_cost,
      followup_cost,
    ];
  }
}
