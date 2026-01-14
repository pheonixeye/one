import 'package:one/models/clinic/schedule_shift.dart';
import 'package:equatable/equatable.dart';
import 'package:one/models/visits/visit.dart';

class Shift extends Equatable {
  final num start_hour;
  final num start_min;
  final num end_hour;
  final num end_min;

  const Shift({
    required this.start_hour,
    required this.start_min,
    required this.end_hour,
    required this.end_min,
  });

  Shift copyWith({
    num? start_hour,
    num? start_min,
    num? end_hour,
    num? end_min,
  }) {
    return Shift(
      start_hour: start_hour ?? this.start_hour,
      start_min: start_min ?? this.start_min,
      end_hour: end_hour ?? this.end_hour,
      end_min: end_min ?? this.end_min,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'start_hour': start_hour,
      'start_min': start_min,
      'end_hour': end_hour,
      'end_min': end_min,
    };
  }

  factory Shift.fromJson(Map<String, dynamic> map) {
    return Shift(
      start_hour: map['start_hour'] as num,
      start_min: map['start_min'] as num,
      end_hour: map['end_hour'] as num,
      end_min: map['end_min'] as num,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [start_hour, start_min, end_hour, end_min];

  factory Shift.fromScheduleShift(ScheduleShift value) {
    return Shift(
      start_hour: value.start_hour,
      start_min: value.start_min,
      end_hour: value.end_hour,
      end_min: value.end_min,
    );
  }

  factory Shift.fromVisit(Visit value) {
    return Shift(
      start_hour: value.s_h,
      start_min: value.s_m,
      end_hour: value.e_h,
      end_min: value.e_m,
    );
  }
}
