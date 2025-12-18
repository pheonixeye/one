import 'package:one/models/notifications/notification_topic.dart';
import 'package:one/models/visits/_visit.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class NotificationRequest extends Equatable {
  final NotificationTopic topic;
  final String? title;
  final String? message;
  final int priority;

  const NotificationRequest({
    required this.topic,
    this.title,
    this.message,
    this.priority = 5,
  });

  NotificationRequest copyWith({
    NotificationTopic? topic,
    String? title,
    String? message,
    int? priority,
  }) {
    return NotificationRequest(
      topic: topic ?? this.topic,
      title: title ?? this.title,
      message: message ?? this.message,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'topic': topic.toTopic(),
      'title': title,
      'message': message,
      'priority': priority,
    };
  }

  Map<String, dynamic> toRequestJson() {
    return <String, dynamic>{
      'topic': topic.toTopic(),
      'title': title,
      'message': message,
      'priority': priority,
    };
  }

  factory NotificationRequest.fromJson(Map<String, dynamic> json) {
    return NotificationRequest(
      topic: NotificationTopic.fromString(json['topic']),
      title: json['title'],
      message: json['message'],
      priority: json['priority'],
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [topic, message, title, priority];

  factory NotificationRequest.fromVisit(Visit visit) {
    final _title = 'تم اضافة حجز جديد';
    final _message =
        '''
اسم المريض : ${visit.patient.name}
تاريخ الحجز : ${DateFormat('dd - MM - yyyy', 'ar').format(visit.visit_date)}
العيادة : ${visit.clinic.name_ar}
نوع الحجز : ${visit.visit_type.name_ar}
الطبيب المعالج : ${visit.doctor.name_ar}
اضافة بواسطة : ${visit.added_by.email}
''';
    return NotificationRequest(
      topic: NotificationTopic.allevia_bookings,
      title: _title,
      message: _message,
    );
  }

  factory NotificationRequest.inclinic(String title, String message) {
    return NotificationRequest(
      topic: NotificationTopic.allevia_inclinic,
      title: title,
      message: message,
    );
  }
}
