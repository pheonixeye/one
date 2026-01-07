import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/blob_file.dart';
// import 'package:one/functions/dprint.dart';
import 'package:one/models/notifications/in_app_notification.dart';
import 'package:one/models/notifications/notification_request.dart';
import 'package:one/models/notifications/notification_topic.dart';
import 'package:one/models/notifications/saved_notification.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart';

class NotificationsApi {
  const NotificationsApi();

  static late final Box<String> _box;

  static const String collection = 'notifications';

  static const _expandList = [
    'read_by.account_type_id',
    'read_by.app_permissions_ids',
  ];

  static final _expand = _expandList.join(',');

  final _url = const String.fromEnvironment('NOTIFICATIONS_URL');

  final sendHeaders = const {'Content-Type': 'Application/Json'};
  final listenHeaders = const {
    'Content-Type': 'application/x-ndjson; charset=utf-8',
    'Transfer-Encoding': 'chunked',
  };

  Future<Map<String, dynamic>> sendNotification({
    // required NotificationTopic topic,
    required NotificationRequest request,
  }) async {
    final uri = Uri.parse(_url);

    final _response = await http.post(
      uri,
      headers: sendHeaders,
      body: jsonEncode(request.toRequestJson()),
    );

    //todo: too much function call per notification
    await saveNotification(
      SavedNotification.fromNotificationRequest(
        request,
        jsonDecode(_response.body)['id'] as String,
      ),
    );

    if (_response.statusCode == HttpStatus.ok) {
      return {'status': 200, 'message': 'ok'};
    } else {
      return {'status': _response.statusCode, 'message': _response.body};
    }
  }

  Future<Stream<InAppNotification>> listenToNotifications({
    required NotificationTopic topic,
  }) async {
    StreamController<InAppNotification> _notificationStreamController =
        StreamController.broadcast();

    final uri = Uri.parse('$_url/${topic.toTopic()}/json');

    final _request = http.Request("GET", uri);

    _request.headers.addAll(listenHeaders);

    _request.persistentConnection = true;

    final _response = await _request.send();

    // print('response stream : ${_response.stream}');

    _response.stream.listen((event) {
      // ignore: unnecessary_null_comparison
      if (event != null && event.isNotEmpty) {
        try {
          final _string = utf8.decode(event);
          final _json = jsonDecode(_string);
          if (_json != null) {
            // print('json : $_json');
            final _notification = InAppNotification.fromJson(_json);
            _notificationStreamController.add(_notification);
          }
        } catch (e) {
          //@handle
          print(e);
        }
      }
    });

    return _notificationStreamController.stream;
  }

  Future<ApiResult<List<SavedNotification>>> fetchNotificationsFromDatabase({
    required int page,
    required int perPage,
  }) async {
    try {
      final _response = await PocketbaseHelper.pbBase
          .collection(collection)
          .getList(
            page: page,
            perPage: perPage,
            expand: _expand,
            sort: '-created',
          );
      // prettyPrint(_response);

      final _notifications = _response.items
          .map(SavedNotification.fromRecordModel)
          .toList();

      return ApiDataResult<List<SavedNotification>>(data: _notifications);
    } catch (e) {
      return ApiErrorResult<List<SavedNotification>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<SavedNotification>> readNotification(
    String id,
    String user_id,
  ) async {
    try {
      final _response = await PocketbaseHelper.pbBase
          .collection(collection)
          .update(id, body: {'+read_by': user_id}, expand: _expand);

      final _notification = SavedNotification.fromRecordModel(_response);

      return ApiDataResult(data: _notification);
    } catch (e) {
      return ApiErrorResult<SavedNotification>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> saveNotification(SavedNotification savedNotification) async {
    await PocketbaseHelper.pbBase
        .collection(collection)
        .create(body: savedNotification.toDto());
  }

  Future<void> initFavoriteNotificationTemplateStore() async {
    _box = await Hive.openBox<String>(collection);
  }

  Future<void> addFavoriteNotification(NotificationRequest request) async {
    final _data = request.toJson();
    await _box.put(request.title, jsonEncode(_data));
  }

  Future<void> removeFavoriteNotification(String title) async {
    await _box.delete(title);
  }

  Future<List<NotificationRequest>> getFavoriteNotifications() async {
    final _result = _box.values.toList();
    return _result
        .map((e) => NotificationRequest.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<Uint8List> fetchNotificationSoundBlob() async {
    final _result = await PocketbaseHelper.pbBase
        .collection('blobs')
        .getFirstListItem("name = 'notification_sound'");

    final _blob = BlobFile.fromRecordModel(_result);

    final _fileRequest = await http.get(Uri.parse(_blob.fileUrl));

    return _fileRequest.bodyBytes;
  }
}
