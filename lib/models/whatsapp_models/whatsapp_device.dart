import 'package:equatable/equatable.dart';

class WhatsappDevice extends Equatable {
  final String name;
  final String device;
  const WhatsappDevice({
    required this.name,
    required this.device,
  });

  WhatsappDevice copyWith({
    String? name,
    String? device,
  }) {
    return WhatsappDevice(
      name: name ?? this.name,
      device: device ?? this.device,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'device': device,
    };
  }

  factory WhatsappDevice.fromJson(Map<String, dynamic> map) {
    return WhatsappDevice(
      name: map['name'] as String,
      device: map['device'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name, device];
}
