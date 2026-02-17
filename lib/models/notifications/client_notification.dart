import 'package:equatable/equatable.dart';

class ClientNotification extends Equatable {
  final String client_token;
  final String message_title;
  final String message_body;

  const ClientNotification({
    required this.client_token,
    required this.message_title,
    required this.message_body,
  });

  ClientNotification copyWith({
    String? client_token,
    String? message_title,
    String? message_body,
  }) {
    return ClientNotification(
      client_token: client_token ?? this.client_token,
      message_title: message_title ?? this.message_title,
      message_body: message_body ?? this.message_body,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'client_token': client_token,
      'message_title': message_title,
      'message_body': message_body,
    };
  }

  factory ClientNotification.fromJson(Map<String, dynamic> map) {
    return ClientNotification(
      client_token: map['client_token'] as String,
      message_title: map['message_title'] as String,
      message_body: map['message_body'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [client_token, message_title, message_body];
}
