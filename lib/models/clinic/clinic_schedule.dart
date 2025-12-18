import 'package:equatable/equatable.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/models/weekdays.dart';
import 'package:uuid/uuid.dart';

class ClinicSchedule implements Equatable {
  final String id;
  final String clinic_id;
  final int intday;
  final List<ScheduleShift> shifts;

  const ClinicSchedule({
    required this.id,
    required this.clinic_id,
    required this.intday,
    required this.shifts,
  });

  ClinicSchedule copyWith({
    String? id,
    String? clinic_id,
    int? intday,
    List<ScheduleShift>? shifts,
  }) {
    return ClinicSchedule(
      id: id ?? this.id,
      clinic_id: clinic_id ?? this.clinic_id,
      intday: intday ?? this.intday,
      shifts: shifts ?? this.shifts,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clinic_id': clinic_id,
      'intday': intday,
      'shifts': shifts.map((e) => e.toJson()).toList(),
    };
  }

  factory ClinicSchedule.fromJson(Map<String, dynamic> map) {
    return ClinicSchedule(
      id: map['id'] as String,
      clinic_id: map['clinic_id'] as String,
      intday: map['intday'] as int,
      shifts: (map['shifts'] as List<dynamic>)
          .map((e) => ScheduleShift.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, clinic_id, intday, shifts];

  Weekday get weekday => Weekdays.getWeekday(intday);

  factory ClinicSchedule.initial(String clinic_id, int intday) {
    return ClinicSchedule(
      id: const Uuid().v4(),
      clinic_id: clinic_id,
      intday: intday,
      shifts: const [],
    );
  }
}
