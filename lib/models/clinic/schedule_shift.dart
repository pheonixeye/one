import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class ScheduleShift implements Equatable {
  final String id;
  final int start_hour;
  final int start_min;
  final int end_hour;
  final int end_min;
  final int visit_count;

  const ScheduleShift({
    required this.id,
    required this.start_hour,
    required this.start_min,
    required this.end_hour,
    required this.end_min,
    required this.visit_count,
  });

  ScheduleShift copyWith({
    String? id,
    int? start_hour,
    int? start_min,
    int? end_hour,
    int? end_min,
    int? visit_count,
  }) {
    return ScheduleShift(
      id: id ?? this.id,
      start_hour: start_hour ?? this.start_hour,
      start_min: start_min ?? this.start_min,
      end_hour: end_hour ?? this.end_hour,
      end_min: end_min ?? this.end_min,
      visit_count: visit_count ?? this.visit_count,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'start_hour': start_hour,
      'start_min': start_min,
      'end_hour': end_hour,
      'end_min': end_min,
      'visit_count': visit_count,
    };
  }

  factory ScheduleShift.fromJson(Map<String, dynamic> map) {
    return ScheduleShift(
      id: map['id'] as String,
      start_hour: map['start_hour'] as int,
      start_min: map['start_min'] as int,
      end_hour: map['end_hour'] as int,
      end_min: map['end_min'] as int,
      visit_count: map['visit_count'] as int,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      start_hour,
      start_min,
      end_hour,
      end_min,
      visit_count,
    ];
  }

  factory ScheduleShift.initial() {
    return ScheduleShift(
      id: const Uuid().v4(),
      start_hour: 0,
      start_min: 0,
      end_hour: 0,
      end_min: 0,
      visit_count: 0,
    );
  }
}
