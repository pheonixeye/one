import 'package:one/models/visit_schedule.dart';
import 'package:equatable/equatable.dart';

class VisitCreateDto extends Equatable {
  final String clinic_id;
  final String patient_id;
  final String added_by_id;
  final String doc_id;
  final String clinic_schedule_id;
  final String clinic_schedule_shift_id;
  final String visit_date;
  final int patient_entry_number;
  final String visit_status_id;
  final String visit_type_id;
  final String patient_progress_status_id;
  final String comments;
  final VisitSchedule visit_schedule;

  const VisitCreateDto({
    required this.clinic_id,
    required this.patient_id,
    required this.added_by_id,
    required this.doc_id,
    required this.clinic_schedule_id,
    required this.clinic_schedule_shift_id,
    required this.visit_date,
    required this.patient_entry_number,
    required this.visit_status_id,
    required this.visit_type_id,
    required this.patient_progress_status_id,
    required this.comments,
    required this.visit_schedule,
  });

  VisitCreateDto copyWith({
    String? clinic_id,
    String? patient_id,
    String? added_by_id,
    String? doc_id,
    String? clinic_schedule_id,
    String? clinic_schedule_shift_id,
    String? visit_date,
    int? patient_entry_number,
    String? visit_status_id,
    String? visit_type_id,
    String? patient_progress_status_id,
    String? comments,
    VisitSchedule? visit_schedule,
  }) {
    return VisitCreateDto(
      clinic_id: clinic_id ?? this.clinic_id,
      patient_id: patient_id ?? this.patient_id,
      added_by_id: added_by_id ?? this.added_by_id,
      doc_id: doc_id ?? this.doc_id,
      clinic_schedule_id: clinic_schedule_id ?? this.clinic_schedule_id,
      clinic_schedule_shift_id:
          clinic_schedule_shift_id ?? this.clinic_schedule_shift_id,
      visit_date: visit_date ?? this.visit_date,
      patient_entry_number: patient_entry_number ?? this.patient_entry_number,
      visit_status_id: visit_status_id ?? this.visit_status_id,
      visit_type_id: visit_type_id ?? this.visit_type_id,
      patient_progress_status_id:
          patient_progress_status_id ?? this.patient_progress_status_id,
      comments: comments ?? this.comments,
      visit_schedule: visit_schedule ?? this.visit_schedule,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'clinic_id': clinic_id,
      'patient_id': patient_id,
      'added_by_id': added_by_id,
      'doc_id': doc_id,
      'clinic_schedule_id': clinic_schedule_id,
      'clinic_schedule_shift_id': clinic_schedule_shift_id,
      'visit_date': visit_date,
      'patient_entry_number': patient_entry_number,
      'visit_status_id': visit_status_id,
      'visit_type_id': visit_type_id,
      'patient_progress_status_id': patient_progress_status_id,
      'comments': comments,
      'visit_schedule': visit_schedule.toJson(),
    };
  }

  factory VisitCreateDto.fromJson(Map<String, dynamic> map) {
    return VisitCreateDto(
      clinic_id: map['clinic_id'] as String,
      patient_id: map['patient_id'] as String,
      added_by_id: map['added_by_id'] as String,
      doc_id: map['doc_id'] as String,
      clinic_schedule_id: map['clinic_schedule_id'] as String,
      clinic_schedule_shift_id: map['clinic_schedule_shift_id'] as String,
      visit_date: map['visit_date'] as String,
      patient_entry_number: map['patient_entry_number'] as int,
      visit_status_id: map['visit_status_id'] as String,
      visit_type_id: map['visit_type_id'] as String,
      patient_progress_status_id: map['patient_progress_status_id'] as String,
      comments: map['comments'] as String,
      visit_schedule: VisitSchedule.fromJson(
        map['visit_schedule'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      clinic_id,
      patient_id,
      added_by_id,
      doc_id,
      clinic_schedule_id,
      clinic_schedule_shift_id,
      visit_date,
      patient_entry_number,
      visit_status_id,
      visit_type_id,
      patient_progress_status_id,
      comments,
      visit_schedule,
    ];
  }
}
