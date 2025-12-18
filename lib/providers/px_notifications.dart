import 'dart:typed_data';

import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/notifications_api.dart';
import 'package:one/models/notifications/in_app_notification.dart';
import 'package:one/models/notifications/notification_request.dart';
import 'package:one/models/notifications/notification_topic.dart';
import 'package:one/models/notifications/saved_notification.dart';
import 'package:one/providers/px_overlay.dart';
import 'package:one/widgets/notification_overlay.dart';
import 'package:flutter/material.dart';

class PxNotifications extends ChangeNotifier {
  final NotificationsApi api;

  PxNotifications({required this.api}) {
    _init();
    _fetchNotifications();
    _initFavoriteNotificationStore();
    if (_fileBlob == null) {
      _fetchNotificationSoundFileBytes();
    }
  }

  Future<void> sendNotification({
    required NotificationTopic topic,
    required NotificationRequest request,
  }) async {
    await api.sendNotification(
      // topic: topic,
      request: request,
    );
  }

  final Map<String, Stream<InAppNotification>> _stream = {};
  Map<String, Stream<InAppNotification>> get stream => _stream;

  Future<void> _listenToNotifications({
    required NotificationTopic topic,
  }) async {
    _stream[topic.toTopic()] = await api.listenToNotifications(topic: topic);
    notifyListeners();
  }

  Future<void> _init() async {
    NotificationTopic.values.map((e) async {
      await _listenToNotifications(topic: e);
      await _displayNotifiationsOnArrivalThenSaveToDb(topic: e);
    }).toList();
  }

  Future<void> get init => _init();

  Future<void> _displayNotifiationsOnArrivalThenSaveToDb({
    required NotificationTopic topic,
  }) async {
    _stream[topic.toTopic()]?.listen((notification) async {
      if (notification.event == 'message') {
        //show notification overlay
        PxOverlay.toggleOverlay(
          id: notification.id ?? '',
          child: NotificationOverlayCard(
            notification: notification,
            fileBlob: _fileBlob,
          ),
        );
        //todo: save notifications in pocketbase
      }
    });
  }

  ApiResult<List<SavedNotification>>? _notifications;
  ApiResult<List<SavedNotification>>? get notifications => _notifications;

  int _page = 1;
  int get page => _page;

  final int _perPage = 20;

  Future<void> _fetchNotifications() async {
    _notifications = await api.fetchNotificationsFromDatabase(
      page: page,
      perPage: _perPage,
    );
    notifyListeners();
  }

  Future<void> retry() async => await _fetchNotifications();

  Future<void> nextPage() async {
    if ((_notifications as ApiDataResult<List<SavedNotification>>).data.length <
        _perPage) {
      return;
    }
    _page++;
    notifyListeners();
    _fetchNotifications();
  }

  Future<void> previousPage() async {
    if (_page <= 1) {
      return;
    }
    _page--;
    notifyListeners();
    _fetchNotifications();
  }

  Future<void> readNotification(String id, String user_id) async {
    final _item = (_notifications as ApiDataResult<List<SavedNotification>>)
        .data
        .firstWhere((e) => e.id == id);
    final _index = (_notifications as ApiDataResult<List<SavedNotification>>)
        .data
        .indexOf(_item);
    (_notifications as ApiDataResult<List<SavedNotification>>).data[_index] =
        (await api.readNotification(id, user_id)
                as ApiDataResult<SavedNotification>)
            .data;
    notifyListeners();
  }

  List<NotificationRequest>? _favoriteNotifications;
  List<NotificationRequest>? get favoriteNotifications =>
      _favoriteNotifications;

  Future<void> _initFavoriteNotificationStore() async {
    await api.initFavoriteNotificationTemplateStore();
    await _fetchFavoriteNotifications();
  }

  Future<void> _fetchFavoriteNotifications() async {
    _favoriteNotifications = await api.getFavoriteNotifications();
    notifyListeners();
  }

  Future<void> saveFavoriteNotification(NotificationRequest request) async {
    await api.addFavoriteNotification(request);
    await _fetchFavoriteNotifications();
  }

  Future<void> removeFavoriteNotification(String title) async {
    await api.removeFavoriteNotification(title);
    await _fetchFavoriteNotifications();
  }

  static Uint8List? _fileBlob;
  Uint8List? get fileBlob => _fileBlob;

  Future<void> _fetchNotificationSoundFileBytes() async {
    _fileBlob = await api.fetchNotificationSoundBlob();
    // print('PxNotifications()._fetchNotificationSoundBlobUrl($_fileUrl)');
    notifyListeners();
  }
}
