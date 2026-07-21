import 'package:equatable/equatable.dart';

class PatientProgressNote extends Equatable {
  final String id;
  final String patient_id;
  final String visit_id;
  final String doc_id;
  final String clinic_id;
  final String subjective;
  final String objective;
  final String assessment;
  final String plan;
  final DateTime visit_date;
  final DateTime time_of_note;

  const PatientProgressNote({
    required this.id,
    required this.patient_id,
    required this.visit_id,
    required this.doc_id,
    required this.clinic_id,
    required this.subjective,
    required this.objective,
    required this.assessment,
    required this.plan,
    required this.visit_date,
    required this.time_of_note,
  });

  PatientProgressNote copyWith({
    String? id,
    String? patient_id,
    String? visit_id,
    String? doc_id,
    String? clinic_id,
    String? subjective,
    String? objective,
    String? assessment,
    String? plan,
    DateTime? visit_date,
    DateTime? time_of_note,
  }) {
    return PatientProgressNote(
      id: id ?? this.id,
      patient_id: patient_id ?? this.patient_id,
      visit_id: visit_id ?? this.visit_id,
      doc_id: doc_id ?? this.doc_id,
      clinic_id: clinic_id ?? this.clinic_id,
      subjective: subjective ?? this.subjective,
      objective: objective ?? this.objective,
      assessment: assessment ?? this.assessment,
      plan: plan ?? this.plan,
      visit_date: visit_date ?? this.visit_date,
      time_of_note: time_of_note ?? this.time_of_note,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'patient_id': patient_id,
      'visit_id': visit_id,
      'doc_id': doc_id,
      'clinic_id': clinic_id,
      'subjective': subjective,
      'objective': objective,
      'assessment': assessment,
      'plan': plan,
      'visit_date': visit_date.toIso8601String(),
      'time_of_note': time_of_note.toIso8601String(),
    };
  }

  factory PatientProgressNote.fromJson(Map<String, dynamic> map) {
    return PatientProgressNote(
      id: map['id'] as String,
      patient_id: map['patient_id'] as String,
      visit_id: map['visit_id'] as String,
      doc_id: map['doc_id'] as String,
      clinic_id: map['clinic_id'] as String,
      subjective: map['subjective'] as String,
      objective: map['objective'] as String,
      assessment: map['assessment'] as String,
      plan: map['plan'] as String,
      visit_date: DateTime.parse(map['visit_date'] as String),
      time_of_note: DateTime.parse(map['time_of_note'] as String),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      patient_id,
      visit_id,
      doc_id,
      clinic_id,
      subjective,
      objective,
      assessment,
      plan,
      visit_date,
      time_of_note,
    ];
  }
}
