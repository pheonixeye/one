import 'package:equatable/equatable.dart';

class WhatsappTextRequest extends Equatable {
  final String phone;
  final String message;
  final String reply_message_id;
  final bool is_forwarded;

  const WhatsappTextRequest({
    required this.phone,
    required this.message,
    this.reply_message_id = '',
    this.is_forwarded = false,
  });

  WhatsappTextRequest copyWith({
    String? phone,
    String? message,
    String? reply_message_id,
    bool? is_forwarded,
  }) {
    return WhatsappTextRequest(
      phone: phone ?? this.phone,
      message: message ?? this.message,
      reply_message_id: reply_message_id ?? this.reply_message_id,
      is_forwarded: is_forwarded ?? this.is_forwarded,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'phone': phone,
      'message': message,
      'reply_message_id': reply_message_id,
      'is_forwarded': is_forwarded,
    };
  }

  factory WhatsappTextRequest.fromJson(Map<String, dynamic> map) {
    return WhatsappTextRequest(
      phone: map['phone'] as String,
      message: map['message'] as String,
      reply_message_id: map['reply_message_id'] as String,
      is_forwarded: map['is_forwarded'] as bool,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        phone,
        message,
        reply_message_id,
        is_forwarded,
      ];
}
