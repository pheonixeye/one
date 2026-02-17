// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class TokenizedNotification extends Equatable {
  final String id;
  final String message_id;
  final String title;
  final String body;
  final String user_token;
  final List<String> read_by;
  final String created;

  const TokenizedNotification({
    required this.id,
    required this.message_id,
    required this.title,
    required this.body,
    required this.user_token,
    required this.read_by,
    required this.created,
  });

  TokenizedNotification copyWith({
    String? id,
    String? message_id,
    String? title,
    String? body,
    String? user_token,
    List<String>? read_by,
    String? created,
  }) {
    return TokenizedNotification(
      id: id ?? this.id,
      message_id: message_id ?? this.message_id,
      title: title ?? this.title,
      body: body ?? this.body,
      user_token: user_token ?? this.user_token,
      read_by: read_by ?? this.read_by,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'message_id': message_id,
      'title': title,
      'body': body,
      'user_token': user_token,
      'read_by': read_by,
      'created': created,
    };
  }

  factory TokenizedNotification.fromJson(Map<String, dynamic> map) {
    return TokenizedNotification(
      id: map['id'] as String,
      message_id: map['message_id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      user_token: map['user_token'] as String,
      read_by: (map['read_by'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      created: map['created'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      message_id,
      title,
      body,
      user_token,
      read_by,
      created,
    ];
  }
}
