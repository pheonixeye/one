// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

enum NotificationType {
  invalid,
  create,
  update;

  factory NotificationType.fromString(String value) {
    return switch (value) {
      'create' => create,
      'update' => update,
      _ => invalid,
    };
  }

  @override
  String toString() {
    return name;
  }
}

class OrgVisitInfo extends Equatable {
  const OrgVisitInfo({
    required this.org_id,
    required this.visit_id,
    required this.type,
  });

  factory OrgVisitInfo.fromJson(Map<String, dynamic> map) {
    return OrgVisitInfo(
      org_id: map['org_id'] as String,
      visit_id: map['visit_id'] as String,
      type: NotificationType.fromString(map['type'] as String),
    );
  }

  final String org_id;
  final String visit_id;
  final NotificationType type;

  OrgVisitInfo copyWith({
    String? org_id,
    String? visit_id,
    NotificationType? type,
  }) {
    return OrgVisitInfo(
      org_id: org_id ?? this.org_id,
      visit_id: visit_id ?? this.visit_id,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'org_id': org_id,
      'visit_id': visit_id,
      'type': type.toString(),
    };
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    org_id,
    visit_id,
    type,
  ];
}
