import 'package:flutter/material.dart' show Color, Colors;

enum NotificationTopic {
  // allevia_testing(
  //   en: 'Testing',
  //   ar: 'اختبار',
  // ),
  allevia_inclinic(
    en: 'In Clinic',
    ar: 'العيادة',
  ),
  allevia_bookings(
    en: 'Bookings',
    ar: 'الحجوزات',
  );

  String toTopic() {
    return name.split('.').last;
  }

  final String en;
  final String ar;

  const NotificationTopic({required this.en, required this.ar});

  factory NotificationTopic.fromString(String value) {
    return switch (value) {
      'allevia_inclinic' => allevia_inclinic,
      'allevia_bookings' => allevia_bookings,
      // 'allevia_testing' => allevia_testing,
      _ => allevia_inclinic,
    };
  }

  Color get tileColor => switch (this) {
        NotificationTopic.allevia_inclinic => Colors.amber.shade50,
        NotificationTopic.allevia_bookings => Colors.deepOrange.shade50,
        // NotificationTopic.allevia_testing => Colors.deepPurple.shade50,
      };
}
