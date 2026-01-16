import 'package:equatable/equatable.dart';
import 'package:one/extensions/datetime_ext.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/clinic/clinic_schedule.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/models/doctor.dart';
import 'package:one/models/patient.dart';
import 'package:pocketbase/pocketbase.dart';

class Visit extends Equatable {
  final String id;
  final String doc_id;
  final String clinic_id;
  final String patient_id;
  final num patient_entry_number;
  final num intday;
  final num s_m;
  final num s_h;
  final num e_m;
  final num e_h;
  final DateTime visit_date;
  final String added_by;
  final String comments;
  final String visit_status;
  final String visit_type;
  final String patient_progress_status;

  const Visit({
    required this.id,
    required this.doc_id,
    required this.clinic_id,
    required this.patient_id,
    required this.patient_entry_number,
    required this.intday,
    required this.s_m,
    required this.s_h,
    required this.e_m,
    required this.e_h,
    required this.visit_date,
    required this.added_by,
    required this.comments,
    required this.visit_status,
    required this.visit_type,
    required this.patient_progress_status,
  });

  Visit copyWith({
    String? id,
    String? doc_id,
    String? clinic_id,
    String? patient_id,
    num? patient_entry_number,
    num? intday,
    num? s_m,
    num? s_h,
    num? e_m,
    num? e_h,
    DateTime? visit_date,
    String? added_by,
    String? comments,
    String? visit_status,
    String? visit_type,
    String? patient_progress_status,
  }) {
    return Visit(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      clinic_id: clinic_id ?? this.clinic_id,
      patient_id: patient_id ?? this.patient_id,
      patient_entry_number: patient_entry_number ?? this.patient_entry_number,
      intday: intday ?? this.intday,
      s_m: s_m ?? this.s_m,
      s_h: s_h ?? this.s_h,
      e_m: e_m ?? this.e_m,
      e_h: e_h ?? this.e_h,
      visit_date: visit_date ?? this.visit_date,
      added_by: added_by ?? this.added_by,
      comments: comments ?? this.comments,
      visit_status: visit_status ?? this.visit_status,
      visit_type: visit_type ?? this.visit_type,
      patient_progress_status:
          patient_progress_status ?? this.patient_progress_status,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'clinic_id': clinic_id,
      'patient_id': patient_id,
      'patient_entry_number': patient_entry_number,
      'intday': intday,
      's_m': s_m,
      's_h': s_h,
      'e_m': e_m,
      'e_h': e_h,
      'visit_date': visit_date.unTimed.toIso8601String(),
      'added_by': added_by,
      'comments': comments,
      'visit_status': visit_status,
      'visit_type': visit_type,
      'patient_progress_status': patient_progress_status,
    };
  }

  factory Visit.fromJson(Map<String, dynamic> map) {
    return Visit(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      clinic_id: map['clinic_id'] as String,
      patient_id: map['patient_id'] as String,
      patient_entry_number: map['patient_entry_number'] as num,
      intday: map['intday'] as num,
      s_m: map['s_m'] as num,
      s_h: map['s_h'] as num,
      e_m: map['e_m'] as num,
      e_h: map['e_h'] as num,
      visit_date: DateTime.parse(map['visit_date'] as String),
      added_by: map['added_by'] as String,
      comments: map['comments'] as String,
      visit_status: map['visit_status'] as String,
      visit_type: map['visit_type'] as String,
      patient_progress_status: map['patient_progress_status'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      doc_id,
      clinic_id,
      patient_id,
      patient_entry_number,
      intday,
      s_m,
      s_h,
      e_m,
      e_h,
      visit_date,
      added_by,
      comments,
      visit_status,
      visit_type,
      patient_progress_status,
    ];
  }

  //HACK
  bool isInSameShift(ClinicSchedule sch, ScheduleShift shift) {
    return sch.shifts.contains(shift);
  }
}

class VisitExpanded extends Visit {
  const VisitExpanded({
    required super.id,
    required super.doc_id,
    required super.clinic_id,
    required super.patient_id,
    required super.patient_entry_number,
    required super.intday,
    required super.s_m,
    required super.s_h,
    required super.e_m,
    required super.e_h,
    required super.visit_date,
    required super.added_by,
    required super.comments,
    required super.visit_status,
    required super.visit_type,
    required super.patient_progress_status,
    required this.clinic,
    required this.patient,
    required this.doctor,
  });

  final Clinic clinic;
  final Doctor doctor;
  final Patient patient;

  factory VisitExpanded.fromRecordModel(RecordModel record) {
    final map = record.data;

    return VisitExpanded(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      clinic_id: map['clinic_id'] as String,
      patient_id: map['patient_id'] as String,
      patient_entry_number: map['patient_entry_number'] as num,
      intday: map['intday'] as num,
      s_m: map['s_m'] as num,
      s_h: map['s_h'] as num,
      e_m: map['e_m'] as num,
      e_h: map['e_h'] as num,
      visit_date: DateTime.parse(map['visit_date'] as String),
      added_by: map['added_by'] as String,
      comments: map['comments'] as String,
      visit_status: map['visit_status'] as String,
      visit_type: map['visit_type'] as String,
      patient_progress_status: map['patient_progress_status'] as String,
      clinic: Clinic.fromJson(
        record.get<RecordModel>('expand.clinic_id').toJson(),
      ),
      patient: Patient.fromJson(
        record.get<RecordModel>('expand.patient_id').toJson(),
      ),
      doctor: Doctor.fromJson(
        record.get<RecordModel>('expand.doc_id').toJson(),
      ),
    );
  }
}
