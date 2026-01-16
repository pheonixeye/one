import 'package:equatable/equatable.dart';

class VisitType extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;

  const VisitType({
    required this.id,
    required this.name_en,
    required this.name_ar,
  });

  VisitType copyWith({
    String? id,
    String? name_en,
    String? name_ar,
  }) {
    return VisitType(
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

  factory VisitType.fromJson(Map<String, dynamic> map) {
    return VisitType(
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

enum VisitTypeEnum {
  Consultation(
    en: 'Consultation',
    ar: 'كشف',
  ),
  FollowUp(
    en: 'FollowUp',
    ar: 'استشارة',
  ),
  Procedure(
    en: 'Procedure',
    ar: 'اجراء طبي',
  );

  final String en;
  final String ar;

  const VisitTypeEnum({
    required this.en,
    required this.ar,
  });

  static String visitType(String en, bool isEnglish) {
    final val = values.firstWhere((e) => e.en == en);
    return isEnglish ? val.en : val.ar;
  }

  static VisitTypeEnum member(String en) {
    return values.firstWhere((e) => e.en == en);
  }
}
