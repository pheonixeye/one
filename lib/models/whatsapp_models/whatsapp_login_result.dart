import 'package:equatable/equatable.dart';

class WhatsappLoginResult extends Equatable {
  final num qr_duration;
  final String qr_link;

  const WhatsappLoginResult({
    required this.qr_duration,
    required this.qr_link,
  });

  WhatsappLoginResult copyWith({
    num? qr_duration,
    String? qr_link,
  }) {
    return WhatsappLoginResult(
      qr_duration: qr_duration ?? this.qr_duration,
      qr_link: qr_link ?? this.qr_link,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'qr_duration': qr_duration,
      'qr_link': qr_link,
    };
  }

  factory WhatsappLoginResult.fromJson(Map<String, dynamic> map) {
    return WhatsappLoginResult(
      qr_duration: map['qr_duration'] as num,
      qr_link: map['qr_link'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [qr_duration, qr_link];
}
