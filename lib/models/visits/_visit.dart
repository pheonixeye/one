import 'package:one/models/doctor.dart';
import 'package:one/models/visit_schedule.dart';
import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/models/app_constants/account_type.dart';
import 'package:one/models/app_constants/app_permission.dart';

import 'package:one/models/app_constants/patient_progress_status.dart';
import 'package:one/models/app_constants/visit_status.dart';
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/clinic/clinic_schedule.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/user/user.dart';

class Visit extends Equatable {
  final String id;
  final Patient patient;
  final Clinic clinic;
  final User added_by;
  final Doctor doctor;
  // final ClinicSchedule clinic_schedule;
  // final ScheduleShift clinic_schedule_shift;
  final DateTime visit_date;
  final int patient_entry_number;
  final VisitStatus visit_status;
  final VisitType visit_type;
  final PatientProgressStatus patient_progress_status;
  final String comments;
  final VisitSchedule visitSchedule;

  const Visit({
    required this.id,
    required this.patient,
    required this.clinic,
    required this.added_by,
    required this.doctor,
    // required this.clinic_schedule,
    // required this.clinic_schedule_shift,
    required this.visit_date,
    required this.patient_entry_number,
    required this.visit_status,
    required this.visit_type,
    required this.patient_progress_status,
    required this.comments,
    required this.visitSchedule,
  });

  Visit copyWith({
    String? id,
    Patient? patient,
    Clinic? clinic,
    User? added_by,
    Doctor? doctor,
    ClinicSchedule? clinic_schedule,
    ScheduleShift? clinic_schedule_shift,
    DateTime? visit_date,
    int? patient_entry_number,
    VisitStatus? visit_status,
    VisitType? visit_type,
    PatientProgressStatus? patient_progress_status,
    String? comments,
    VisitSchedule? visitSchedule,
  }) {
    return Visit(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      clinic: clinic ?? this.clinic,
      added_by: added_by ?? this.added_by,
      doctor: doctor ?? this.doctor,
      // clinic_schedule: clinic_schedule ?? this.clinic_schedule,
      // clinic_schedule_shift:
      //     clinic_schedule_shift ?? this.clinic_schedule_shift,
      visit_date: visit_date ?? this.visit_date,
      patient_entry_number: patient_entry_number ?? this.patient_entry_number,
      visit_status: visit_status ?? this.visit_status,
      visit_type: visit_type ?? this.visit_type,
      patient_progress_status:
          patient_progress_status ?? this.patient_progress_status,
      comments: comments ?? this.comments,
      visitSchedule: visitSchedule ?? this.visitSchedule,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'patient': patient.toJson(),
      'clinic': clinic.toJson(),
      'added_by': added_by.toJson(),
      'doctor': doctor.toJson(),
      // 'clinic_schedule': clinic_schedule.toJson(),
      // 'clinic_schedule_shift_id': clinic_schedule_shift.toJson(),
      'visit_date': visit_date.toIso8601String(),
      'patient_entry_number': patient_entry_number,
      'visit_status': visit_status.toJson(),
      'visit_type': visit_type.toJson(),
      'patient_progress_status': patient_progress_status.toJson(),
      'comments': comments,
      'visit_schedule': visitSchedule.toJson(),
    };
  }

  factory Visit.fromJson(Map<String, dynamic> map) {
    return Visit(
      id: map['id'] as String,
      patient: Patient.fromJson(map['patient'] as Map<String, dynamic>),
      clinic: Clinic.fromJson(map['clinic'] as Map<String, dynamic>),
      added_by: User.fromJson(map['added_by'] as Map<String, dynamic>),
      doctor: Doctor.fromJson(map['doctor'] as Map<String, dynamic>),
      // clinic_schedule: ClinicSchedule.fromJson(
      //     map['clinic_schedule'] as Map<String, dynamic>),
      // clinic_schedule_shift: ScheduleShift.fromJson(
      //     map['clinic_schedule_shift'] as Map<String, dynamic>),
      visit_date: DateTime.parse(map['visit_date'] as String),
      patient_entry_number: map['patient_entry_number'] as int,
      visit_status: VisitStatus.fromJson(
        map['visit_status'] as Map<String, dynamic>,
      ),
      visit_type: VisitType.fromJson(map['visit_type'] as Map<String, dynamic>),
      patient_progress_status: PatientProgressStatus.fromJson(
        map['patient_progress_status'] as Map<String, dynamic>,
      ),
      comments: map['comments'] as String,
      visitSchedule: VisitSchedule.fromJson(
        map['visit_schedule'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      patient,
      clinic,
      added_by,
      doctor,
      // clinic_schedule,
      // clinic_schedule_shift,
      visit_date,
      patient_entry_number,
      visit_status,
      visit_type,
      patient_progress_status,
      comments,
      visitSchedule,
    ];
  }

  factory Visit.fromRecordModel(RecordModel e) {
    final _clinic = Clinic.fromJson(
      e.get<RecordModel>('expand.clinic_id').toJson(),
    );

    return Visit(
      id: e.id,
      patient: Patient.fromJson(
        e.get<RecordModel>('expand.patient_id').toJson(),
      ),
      clinic: _clinic,
      doctor: Doctor.fromJson({
        ...e.get<RecordModel>('expand.doc_id').toJson(),
        'speciality': e
            .get<RecordModel>('expand.doc_id.expand.speciality_id')
            .toJson(),
      }),
      added_by: User(
        id: e.get<RecordModel>('expand.added_by_id').toJson()['id'],
        email: e.get<RecordModel>('expand.added_by_id').toJson()['email'],
        name: e.get<RecordModel>('expand.added_by_id').toJson()['name'],
        verified: e.get<RecordModel>('expand.added_by_id').toJson()['verified'],
        is_active: e
            .get<RecordModel>('expand.added_by_id')
            .toJson()['is_active'],
        account_type: AccountType.fromJson(
          e
              .get<RecordModel>('expand.added_by_id.expand.account_type_id')
              .toJson(),
        ),
        app_permissions: (e.get<List<RecordModel>>(
          'expand.added_by_id.expand.app_permissions_ids',
        )).map((e) => AppPermission.fromJson(e.toJson())).toList(),
      ),
      // clinic_schedule: _clinic_schedule,
      // clinic_schedule_shift: _schedule_shift,
      visit_date: DateTime.parse(e.getStringValue('visit_date')),
      patient_entry_number: e.getIntValue('patient_entry_number'),
      visit_status: VisitStatus.fromJson(
        e.get<RecordModel>('expand.visit_status_id').toJson(),
      ),
      visit_type: VisitType.fromJson(
        e.get<RecordModel>('expand.visit_type_id').toJson(),
      ),
      patient_progress_status: PatientProgressStatus.fromJson(
        e.get<RecordModel>('expand.patient_progress_status_id').toJson(),
      ),
      comments: e.getStringValue('comments'),
      visitSchedule: VisitSchedule.fromJson(
        e.get<RecordModel>('expand.visit_schedule_id').toJson(),
      ),
    );
  }
}
