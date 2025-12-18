import 'package:equatable/equatable.dart';

class LogEntry extends Equatable {
  final String id;
  final String item_id;
  final String collection_id;
  final String message;
  final String user_id;

  const LogEntry({
    required this.id,
    required this.item_id,
    required this.collection_id,
    required this.message,
    required this.user_id,
  });

  LogEntry copyWith({
    String? id,
    String? item_id,
    String? collection_id,
    String? message,
    String? user_id,
  }) {
    return LogEntry(
      id: id ?? this.id,
      item_id: item_id ?? this.item_id,
      collection_id: collection_id ?? this.collection_id,
      message: message ?? this.message,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'item_id': item_id,
      'collection_id': collection_id,
      'message': message,
      'user_id': user_id,
    };
  }

  factory LogEntry.fromJson(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'] as String,
      item_id: map['item_id'] as String,
      collection_id: map['collection_id'] as String,
      message: map['message'] as String,
      user_id: map['user_id'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        item_id,
        collection_id,
        message,
        user_id,
      ];
}
