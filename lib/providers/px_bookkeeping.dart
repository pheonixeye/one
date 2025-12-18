import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/models/bookkeeping/bookkeeping_item_dto.dart';

class PxBookkeeping extends ChangeNotifier {
  final BookkeepingApi api;

  PxBookkeeping({required this.api}) {
    _fetchDetailedItems();
  }

  final _now = DateTime.now();

  ApiResult<List<BookkeepingItem>>? _result;
  ApiResult<List<BookkeepingItem>>? get result => _result;

  late DateTime _from = DateTime(_now.year, _now.month, 1);
  DateTime get from => _from;

  late DateTime _to = DateTime(_now.year, _now.month + 1, 1);
  DateTime get to => _to;

  Future<void> _fetchDetailedItems() async {
    _result = await api.fetchDetailedItems(from: from, to: to);
    notifyListeners();
    _foldBookKeeping();
  }

  Future<void> retry() async => await _fetchDetailedItems();

  Future<void> changeDate({
    required DateTime from,
    required DateTime to,
  }) async {
    _from = from;
    _to = to;
    notifyListeners();
    await _fetchDetailedItems();
  }

  Future<void> addBookkeepingEntry(BookkeepingItemDto dto) async {
    await api.addBookkeepingItem(dto);
    await _fetchDetailedItems();
  }

  BookkeepingViewType _viewType = BookkeepingViewType.detailed;
  BookkeepingViewType get viewType => _viewType;

  void toggleView() {
    _viewType = _viewType == BookkeepingViewType.detailed
        ? BookkeepingViewType.focused
        : BookkeepingViewType.detailed;
    notifyListeners();
  }

  final Map<String, double> _foldedBookkeeping = {};
  Map<String, double> get foldedBookkeeping => _foldedBookkeeping;

  void _foldBookKeeping() {
    if (_result != null && _result! is ApiDataResult) {
      final _data = (_result as ApiDataResult<List<BookkeepingItem>>).data;
      _data.map((e) {
        if (_foldedBookkeeping['${e.item_id}-${e.collection_id}'] == null) {
          _foldedBookkeeping['${e.item_id}-${e.collection_id}'] = 0;
        } else {
          _foldedBookkeeping['${e.item_id}-${e.collection_id}'] =
              _foldedBookkeeping['${e.item_id}-${e.collection_id}']! + e.amount;
        }
      }).toList();
      notifyListeners();
    }
  }
}

enum BookkeepingViewType { detailed, focused }
