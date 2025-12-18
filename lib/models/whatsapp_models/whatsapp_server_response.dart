import 'package:equatable/equatable.dart';

class WhatsappServerResponse<T> extends Equatable {
  final String code;
  final String message;
  final T? results;

  const WhatsappServerResponse({
    required this.code,
    required this.message,
    this.results,
  });

  WhatsappServerResponse copyWith({
    String? code,
    String? message,
    T? results,
  }) {
    return WhatsappServerResponse(
      code: code ?? this.code,
      message: message ?? this.message,
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'message': message,
      'results': results,
    };
  }

  factory WhatsappServerResponse.fromJson(Map<String, dynamic> map) {
    return WhatsappServerResponse(
      code: map['code'] as String,
      message: map['message'] as String,
      results: map['results'] as T?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        code,
        message,
        results,
      ];
}
