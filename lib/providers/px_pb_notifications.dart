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
  int get page => _page;

  ApiDataResult<List<TokenizedNotification>>? _data;
  ApiDataResult<List<TokenizedNotification>>? get data => _data;

  final List<TokenizedNotification> _notifications = [];
  List<TokenizedNotification> get notifications => _notifications;

  Future<void> _fetchNotifications() async {
    _data =
        await api.fetchNotifications(page: page)
            as ApiDataResult<List<TokenizedNotification>>;
    if (_data != null) {
      _notifications.addAll(_data!.data);
      notifyListeners();
    }
  }

  Future<void> retry() async => await _fetchNotifications();

  Future<void> fetchNextBatch() async {
    if (_data != null && _data!.data.length == 10) {
      print('fetchNextBatch($page)');
      _page++;
      _isLoading = true;
      notifyListeners();
      await _fetchNotifications();
      _isLoading = false;
      notifyListeners();
      return;
    }
    return;
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

  bool get hasMore =>
      _data != null &&
      (_data as ApiDataResult<List<TokenizedNotification>>).data.length == 10;
}
