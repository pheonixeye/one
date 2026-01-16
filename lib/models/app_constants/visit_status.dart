import 'package:equatable/equatable.dart';

class VisitStatus extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;

  const VisitStatus({
    required this.id,
    required this.name_en,
    required this.name_ar,
  });

  VisitStatus copyWith({
    String? id,
    String? name_en,
    String? name_ar,
  }) {
    return VisitStatus(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
    };
  }

  factory VisitStatus.fromJson(Map<String, dynamic> map) {
    return VisitStatus(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name_en, name_ar];
}

enum VisitStatusEnum {
  Attended(
    en: 'Attended',
    ar: 'تم الحضور',
  ),
  NotAttended(
    en: 'Not Attended',
    ar: 'لم يتم الحضور',
  );

  final String en;
  final String ar;

  const VisitStatusEnum({
    required this.en,
    required this.ar,
  });

  static String visitStatus(String en, bool isEnglish) {
    final val = values.firstWhere((e) => e.en == en);
    return isEnglish ? val.en : val.ar;
  }

  static VisitStatusEnum member(String en) {
    return values.firstWhere((e) => e.en == en);
  }
}
