import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:flutter/material.dart';

class PxOneVisitBookkeeping extends ChangeNotifier {
  final BookkeepingApi api;

  PxOneVisitBookkeeping({required this.api}) {
    _init();
  }

  ApiResult<List<BookkeepingItem>>? _result;
  ApiResult<List<BookkeepingItem>>? get result => _result;

  Future<void> _init() async {
    _result = await api.fetchBookkeepingOfOneVisit();
    notifyListeners();
    _filterDiscounts();
  }

  Future<void> retry() async => await _init();

  Future<void> addBookkeepingEntry(BookkeepingItem dto) async {
    await api.addBookkeepingItem(dto);
    await _init();
  }

  List<BookkeepingItem>? _visitDiscounts;
  List<BookkeepingItem>? get visitDiscounts => _visitDiscounts;

  double? _discountTotal;
  double? get discountTotal => _discountTotal;

  void _filterDiscounts() {
    if (_result != null && _result is ApiDataResult<List<BookkeepingItem>>) {
      final _items = (_result as ApiDataResult<List<BookkeepingItem>>).data;
      _visitDiscounts = _items
          .where((e) => e.item_name.contains('discount'))
          .toList();
      _discountTotal = _visitDiscounts
          ?.map((e) => e.amount)
          .fold<double>(0, (a, b) => a + b);
      notifyListeners();
    }
  }
}
