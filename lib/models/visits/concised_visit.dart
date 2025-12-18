import 'package:one/models/patient.dart';
import 'package:equatable/equatable.dart';

import 'package:one/models/user/concised_user.dart';
import 'package:one/models/visit_schedule.dart';
import 'package:pocketbase/pocketbase.dart';

class ConcisedVisit extends Equatable {
  final String id;
  final String doc_id;
  final String clinic_id;
  final Patient patient;
  final ConcisedUser added_by;
  final String visit_date;
  final String visit_status_id;
  final String visit_type_id;
  final String patient_progress_status_id;
  final VisitSchedule visit_schedule;
  final String created;

  const ConcisedVisit({
    required this.id,
    required this.doc_id,
    required this.clinic_id,
    required this.patient,
    required this.added_by,
    required this.visit_date,
    required this.visit_status_id,
    required this.visit_type_id,
    required this.patient_progress_status_id,
    required this.visit_schedule,
    required this.created,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      doc_id,
      clinic_id,
      patient,
      added_by,
      visit_date,
      visit_status_id,
      visit_type_id,
      patient_progress_status_id,
      visit_schedule,
      created,
    ];
  }

  factory ConcisedVisit.fromRecordModel(RecordModel e) {
    return ConcisedVisit(
      id: e.getStringValue('id'),
      doc_id: e.getStringValue('doc_id'),
      clinic_id: e.getStringValue('clinic_id'),
      patient: Patient.fromJson(
        e.get<RecordModel>('expand.patient_id').toJson(),
      ),
      added_by: ConcisedUser.fromJson(
        e.get<RecordModel>('expand.added_by_id').toJson(),
      ),
      visit_date: e.getStringValue('visit_date'),
      visit_status_id: e.getStringValue('visit_status_id'),
      visit_type_id: e.getStringValue('visit_type_id'),
      patient_progress_status_id: e.getStringValue(
        'patient_progress_status_id',
      ),
      visit_schedule: VisitSchedule.fromJson(
        e.get<RecordModel>('expand.visit_schedule_id').toJson(),
      ),
      created: e.getStringValue('created'),
    );
  }
}
