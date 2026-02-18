import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/pb_notifications_api.dart';
import 'package:one/models/notifications/tokenized_notification.dart';

class PxPbNotifications extends ChangeNotifier {
  final PbNotificationsApi api;

  PxPbNotifications({required this.api}) {
    _fetchNotifications();
    _watchCollectionUpdates();
  }

  int _page = 1;

  static const _perPage = 10;

  ApiDataResult<List<TokenizedNotification>>? _data;
  ApiDataResult<List<TokenizedNotification>>? get data => _data;

  List<TokenizedNotification> _notifications = [];
  List<TokenizedNotification> get notifications => _notifications;

  Future<void> _fetchNotifications() async {
    _data =
        await api.fetchNotifications(
              page: _page,
              perPage: _perPage,
            )
            as ApiDataResult<List<TokenizedNotification>>;
    if (_data != null) {
      _notifications = [..._notifications, ..._data!.data];
      notifyListeners();
    }
  }

  Future<void> retry() async => await _fetchNotifications();

  Future<void> fetchNextBatch() async {
    if (_data != null && _data!.data.length == _perPage) {
      _page++;
      print('fetchNextBatch($_page)');
      toggleLoading();
      await _fetchNotifications();
      toggleLoading();
    }
  }

  Future<void> markNotificationAsReadByUser({
    required TokenizedNotification notification,
    required String user_id,
  }) async {
    final _updated = await api.markNotificationAsReadByUser(
      notification: notification,
      user_id: user_id,
    );
    if (_updated is! ApiErrorResult) {
      final _tokenized =
          (_updated as ApiDataResult<TokenizedNotification>).data;
      final _index = _notifications.indexWhere((e) => e.id == notification.id);
      _notifications[_index] = _tokenized;
      notifyListeners();
    }
  }

  Future<void> Function()? _unsubscribe;

  Future<void> _watchCollectionUpdates() async {
    _unsubscribe = await api.notificationsSubscription((event) async {
      if (event.action == 'create' && event.record != null) {
        final _tokenized = TokenizedNotification.fromJson(
          event.record!.toJson(),
        );
        _notifications.insert(0, _tokenized);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    if (_unsubscribe != null) {
      _unsubscribe!();
    }
    super.dispose();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
