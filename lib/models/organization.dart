import 'package:equatable/equatable.dart';

class Organization extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;
  final List<String> members;
  final String activity;
  final String pb_endpoint;
  final String s3_endpoint;
  final String s3_key;
  final String s3_secret;
  final String s3_bucket;

  const Organization({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.members,
    required this.activity,
    required this.pb_endpoint,
    required this.s3_endpoint,
    required this.s3_key,
    required this.s3_secret,
    required this.s3_bucket,
  });

  Organization copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    List<String>? members,
    String? activity,
    String? pb_endpoint,
    String? s3_endpoint,
    String? s3_key,
    String? s3_secret,
    String? s3_bucket,
  }) {
    return Organization(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      members: members ?? this.members,
      activity: activity ?? this.activity,
      pb_endpoint: pb_endpoint ?? this.pb_endpoint,
      s3_endpoint: s3_endpoint ?? this.s3_endpoint,
      s3_key: s3_key ?? this.s3_key,
      s3_secret: s3_secret ?? this.s3_secret,
      s3_bucket: s3_bucket ?? this.s3_bucket,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'members': members,
      'activity': activity,
      'pb_endpoint': pb_endpoint,
      's3_endpoint': s3_endpoint,
      's3_key': s3_key,
      's3_secret': s3_secret,
      's3_bucket': s3_bucket,
    };
  }

  factory Organization.fromJson(Map<String, dynamic> map) {
    return Organization(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      members: List<String>.from((map['members'] as List<dynamic>)),
      activity: map['activity'] as String,
      pb_endpoint: map['pb_endpoint'] as String,
      s3_endpoint: map['s3_endpoint'] as String,
      s3_key: map['s3_key'] as String,
      s3_secret: map['s3_secret'] as String,
      s3_bucket: map['s3_bucket'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name_en,
      name_ar,
      members,
      activity,
      pb_endpoint,
      s3_endpoint,
      s3_key,
      s3_secret,
      s3_bucket,
    ];
  }
}
