import 'package:equatable/equatable.dart';
import 'package:one/models/user/concised_user.dart';
import 'package:pocketbase/pocketbase.dart';

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

class OrganizationExpanded extends Organization {
  const OrganizationExpanded({
    required super.id,
    required super.name_en,
    required super.name_ar,
    required super.members,
    required super.activity,
    required super.pb_endpoint,
    required super.s3_endpoint,
    required super.s3_key,
    required super.s3_secret,
    required super.s3_bucket,
    required this.orgUsers,
  });

  final List<ConcisedUserWithFcmToken> orgUsers;

  factory OrganizationExpanded.fromRecordModel(RecordModel record) {
    final orgUsers = record
        .getListValue<RecordModel>('expand.members')
        .map((e) => ConcisedUserWithFcmToken.fromRecordModel(e))
        .toList();
    return OrganizationExpanded(
      id: record.getStringValue('id'),
      name_en: record.getStringValue('name_en'),
      name_ar: record.getStringValue('name_ar'),
      members: record.getListValue<String>('members'),
      activity: record.getStringValue('activity'),
      pb_endpoint: record.getStringValue('pb_endpoint'),
      s3_endpoint: record.getStringValue('s3_endpoint'),
      s3_key: record.getStringValue('s3_key'),
      s3_secret: record.getStringValue('s3_secret'),
      s3_bucket: record.getStringValue('s3_bucket'),
      orgUsers: orgUsers,
    );
  }
}
