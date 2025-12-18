import 'package:equatable/equatable.dart';

class RecieptInfo extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String address;
  final String footer;
  final String phone;

  const RecieptInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.address,
    required this.footer,
    required this.phone,
  });

  RecieptInfo copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? address,
    String? footer,
    String? phone,
  }) {
    return RecieptInfo(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      address: address ?? this.address,
      footer: footer ?? this.footer,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'address': address,
      'footer': footer,
      'phone': phone,
    };
  }

  factory RecieptInfo.fromJson(Map<String, dynamic> map) {
    return RecieptInfo(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      address: map['address'] as String,
      footer: map['footer'] as String,
      phone: map['phone'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      title,
      subtitle,
      address,
      footer,
      phone,
    ];
  }
}
