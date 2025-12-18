import 'package:one/models/clinic/clinic_schedule.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:equatable/equatable.dart';

class VisitSchedule extends Equatable {
  final String id;
  final String clinic_id;
  final String visit_id;
  final int intday;
  final int start_hour;
  final int start_min;
  final int end_hour;
  final int end_min;

  const VisitSchedule({
    required this.id,
    required this.clinic_id,
    required this.visit_id,
    required this.intday,
    required this.start_hour,
    required this.start_min,
    required this.end_hour,
    required this.end_min,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clinic_id': clinic_id,
      'visit_id': visit_id,
      'intday': intday,
      'start_hour': start_hour,
      'start_min': start_min,
      'end_hour': end_hour,
      'end_min': end_min,
    };
  }

  factory VisitSchedule.fromJson(Map<String, dynamic> map) {
    return VisitSchedule(
      id: map['id'] as String,
      clinic_id: map['clinic_id'] as String,
      visit_id: map['visit_id'] as String,
      intday: map['intday'] as int,
      start_hour: map['start_hour'] as int,
      start_min: map['start_min'] as int,
      end_hour: map['end_hour'] as int,
      end_min: map['end_min'] as int,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      clinic_id,
      visit_id,
      intday,
      start_hour,
      start_min,
      end_hour,
      end_min,
    ];
  }

  VisitSchedule copyWith({
    String? id,
    String? clinic_id,
    String? visit_id,
    int? intday,
    int? start_hour,
    int? start_min,
    int? end_hour,
    int? end_min,
  }) {
    return VisitSchedule(
      id: id ?? this.id,
      clinic_id: clinic_id ?? this.clinic_id,
      visit_id: visit_id ?? this.visit_id,
      intday: intday ?? this.intday,
      start_hour: start_hour ?? this.start_hour,
      start_min: start_min ?? this.start_min,
      end_hour: end_hour ?? this.end_hour,
      end_min: end_min ?? this.end_min,
    );
  }

  bool isInSameShift(ClinicSchedule schedule, ScheduleShift shift) {
    return schedule.intday == intday &&
        shift.start_hour == start_hour &&
        shift.end_hour == end_hour &&
        shift.start_min == start_min &&
        shift.end_min == end_min;
  }
}
