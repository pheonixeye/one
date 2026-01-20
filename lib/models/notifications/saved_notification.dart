import 'package:one/models/app_constants/account_type.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/notifications/in_app_notification.dart';
import 'package:one/models/notifications/notification_request.dart';
import 'package:equatable/equatable.dart';

import 'package:one/models/notifications/notification_topic.dart';
import 'package:one/models/user/user.dart';
import 'package:pocketbase/pocketbase.dart';

class SavedNotification extends Equatable {
  final String id;
  final String server_id;
  final String title;
  final String message;
  final List<User> read_by;
  final NotificationTopic notification_topic;
  final String created;

  const SavedNotification({
    required this.id,
    required this.server_id,
    required this.title,
    required this.message,
    required this.read_by,
    required this.notification_topic,
    required this.created,
  });

  SavedNotification copyWith({
    String? id,
    String? server_id,
    String? title,
    String? message,
    List<User>? read_by,
    NotificationTopic? notification_topic,
    String? created,
  }) {
    return SavedNotification(
      id: id ?? this.id,
      server_id: server_id ?? this.server_id,
      title: title ?? this.title,
      message: message ?? this.message,
      read_by: read_by ?? this.read_by,
      notification_topic: notification_topic ?? this.notification_topic,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'server_id': server_id,
      'title': title,
      'message': message,
      'read_by': read_by.map((x) => x.toJson()).toList(),
      'notification_topic': notification_topic.toTopic(),
    };
  }

  Map<String, dynamic> toDto() {
    return <String, dynamic>{
      'id': id,
      'server_id': server_id,
      'title': title,
      'message': message,
      'read_by': read_by.map((x) => x.id).toList(),
      'notification_topic': notification_topic.toTopic(),
    };
  }

  factory SavedNotification.fromRecordModel(RecordModel record) {
    return SavedNotification(
      id: record.id,
      server_id: record.getStringValue('server_id'),
      title: record.getStringValue('title'),
      message: record.getStringValue('message'),
      read_by: record
          .getListValue<RecordModel>('expand.read_by')
          .map(
            (e) => User(
              id: e.getStringValue('id'),
              email: e.getStringValue('email'),
              name: e.getStringValue('name'),
              org_id: e.getStringValue('org_id'),
              verified: e.getBoolValue('verified'),
              is_active: e.getBoolValue('is_active'),
              account_type: AccountType.fromJson(
                e.get<RecordModel>('expand.account_type_id').toJson(),
              ),
              app_permissions: e
                  .getListValue<RecordModel>('expand.app_permissions_ids')
                  .map((e) => AppPermission.fromJson(e.toJson()))
                  .toList(),
            ),
          )
          .toList(),
      notification_topic: NotificationTopic.fromString(
        record.getStringValue('notification_topic'),
      ),
      created: record.getStringValue('created'),
    );
  }

  factory SavedNotification.fromInAppNotification(
    InAppNotification inAppNotification,
  ) {
    return SavedNotification(
      id: '',
      server_id: inAppNotification.id ?? '',
      title: inAppNotification.title ?? '',
      message: inAppNotification.message ?? '',
      read_by: [],
      notification_topic: NotificationTopic.fromString(
        inAppNotification.topic ?? '',
      ),
      created: '',
    );
  }

  factory SavedNotification.fromNotificationRequest(
    NotificationRequest request,
    String server_id,
  ) {
    return SavedNotification(
      id: '',
      server_id: server_id,
      title: request.title ?? '',
      message: request.message ?? '',
      read_by: [],
      notification_topic: request.topic,
      created: '',
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      server_id,
      title,
      message,
      read_by,
      notification_topic,
      created,
    ];
  }
}
