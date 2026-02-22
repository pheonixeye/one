import 'package:equatable/equatable.dart';

class Plan extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;
  final num duration_in_days;

  const Plan({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.duration_in_days,
  });

  Plan copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    num? duration_in_days,
  }) {
    return Plan(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      duration_in_days: duration_in_days ?? this.duration_in_days,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'duration_in_days': duration_in_days,
    };
  }

  factory Plan.fromJson(Map<String, dynamic> map) {
    return Plan(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      duration_in_days: map['duration_in_days'] as num,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name_en, name_ar, duration_in_days];
}
