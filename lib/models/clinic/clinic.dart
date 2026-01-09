import 'package:equatable/equatable.dart';
import 'package:one/models/clinic/clinic_schedule.dart';

class Clinic implements Equatable {
  final String id;
  final String name_en;
  final String name_ar;
  final List<String> doc_id;
  final String phone_number;
  final int consultation_fees;
  final int followup_fees;
  final int followup_duration;
  final int procedure_fees;
  final bool is_main;
  final bool is_active;
  final String prescription_file;
  final List<ClinicSchedule> clinic_schedule;

  const Clinic({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.doc_id,
    required this.phone_number,
    required this.consultation_fees,
    required this.followup_fees,
    required this.procedure_fees,
    required this.followup_duration,
    required this.is_main,
    required this.is_active,
    required this.prescription_file,
    required this.clinic_schedule,
  });

  Clinic copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    List<String>? doc_id,
    String? phone_number,
    int? consultation_fees,
    int? followup_fees,
    int? procedure_fees,
    int? followup_duration,
    bool? is_main,
    bool? is_active,
    String? prescription_file,
    List<ClinicSchedule>? clinic_schedule,
  }) {
    return Clinic(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      doc_id: doc_id ?? this.doc_id,
      phone_number: phone_number ?? this.phone_number,
      consultation_fees: consultation_fees ?? this.consultation_fees,
      followup_fees: followup_fees ?? this.followup_fees,
      procedure_fees: procedure_fees ?? this.procedure_fees,
      followup_duration: followup_duration ?? this.followup_duration,
      is_main: is_main ?? this.is_main,
      is_active: is_active ?? this.is_active,
      prescription_file: prescription_file ?? this.prescription_file,
      clinic_schedule: clinic_schedule ?? this.clinic_schedule,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'doc_id': doc_id.map((e) => e.toString()).toList(),
      'phone_number': phone_number,
      'consultation_fees': consultation_fees,
      'followup_fees': followup_fees,
      'procedure_fees': procedure_fees,
      'followup_duration': followup_duration,
      'is_main': is_main,
      'is_active': is_active,
      'prescription_file': prescription_file,
      'clinic_schedule': clinic_schedule.map((e) => e.toJson()).toList(),
    };
  }

  factory Clinic.fromJson(Map<String, dynamic> map) {
    return Clinic(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      doc_id: (map['doc_id'] as List).map((e) => e.toString()).toList(),
      phone_number: map['phone_number'] as String,
      consultation_fees: map['consultation_fees'] as int,
      followup_fees: map['followup_fees'] as int,
      procedure_fees: map['procedure_fees'] as int,
      followup_duration: map['followup_duration'] as int,
      is_main: map['is_main'] as bool,
      is_active: map['is_active'] as bool,
      prescription_file: map['prescription_file'] as String,
      clinic_schedule: (map['clinic_schedule'] as List<dynamic>)
          .map((e) => ClinicSchedule.fromJson(e))
          .toList(),
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
      doc_id,
      phone_number,
      consultation_fees,
      followup_fees,
      procedure_fees,
      followup_duration,
      is_main,
      is_active,
      prescription_file,
      clinic_schedule,
    ];
  }
}
