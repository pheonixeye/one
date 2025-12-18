// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Weekday extends Equatable {
  final String en;
  final String ar;
  final int id;

  const Weekday({
    required this.en,
    required this.ar,
    required this.id, //intday
  });

  @override
  List<Object?> get props => [en, ar, id];
}

class Weekdays extends Equatable {
  static const List<Weekday> _weekdays = [
    Weekday(en: 'Monday', ar: 'الاثنين', id: 1),
    Weekday(en: 'Tuesday', ar: 'الثلاثاء', id: 2),
    Weekday(en: 'Wednesday', ar: 'الاربعاء', id: 3),
    Weekday(en: 'Thursday', ar: 'الخميس', id: 4),
    Weekday(en: 'Friday', ar: 'الجمعة', id: 5),
    Weekday(en: 'Saturday', ar: 'السبت', id: 6),
    Weekday(en: 'Sunday', ar: 'الاحد', id: 7),
  ];

  static List<Weekday> get weekdays => _weekdays;

  static Weekday getWeekday(int intday) {
    return _weekdays.firstWhere((e) => e.id == intday);
  }

  @override
  List<Object?> get props => [_weekdays];
}
