import 'package:equatable/equatable.dart';

class InAppNotification extends Equatable {
  final String? id;
  final int? time;
  final String? event;
  final String? topic;
  final String? title;
  final String? message;
  final int? priority;
  // final List<String>? tags;

  const InAppNotification({
    this.id,
    this.time,
    this.event,
    this.topic,
    this.title,
    this.message,
    this.priority,
    // this.tags,
  });

  InAppNotification copyWith({
    String? id,
    int? time,
    String? event,
    String? topic,
    String? title,
    String? message,
    int? priority,
    // List<String>? tags,
  }) {
    return InAppNotification(
      id: id ?? this.id,
      time: time ?? this.time,
      event: event ?? this.event,
      topic: topic ?? this.topic,
      title: title ?? this.title,
      message: message ?? this.message,
      priority: priority ?? this.priority,
      // tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'time': time,
      'event': event,
      'topic': topic,
      'title': title,
      'message': message,
      'priority': priority,
      // 'tags': tags,
    };
  }

  factory InAppNotification.fromJson(Map<String, dynamic> map) {
    return InAppNotification(
      id: map['id'] != null ? map['id'] as String : null,
      time: map['time'] != null ? map['time'] as int : null,
      event: map['event'] != null ? map['event'] as String : null,
      topic: map['topic'] != null ? map['topic'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      priority: map['priority'] != null ? map['priority'] as int : null,
      // tags: map['tags'] != null
      //     ? (map['tags'] as JSArray<JSAny>)
      //         .toDart
      //         .map((e) => e.toString())
      //         .toList()
      //     : null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      time,
      event,
      topic,
      title,
      message,
      priority,
      // tags,
    ];
  }
}
