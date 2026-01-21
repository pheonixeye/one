import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';

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

  Future<void> addBookkeepingEntry(BookkeepingItem dto) async {
    await api.addBookkeepingItem(dto);
    await _fetchDetailedItems();
  }

  BookkeepingViewType _viewType = BookkeepingViewType.detailed;
  BookkeepingViewType get viewType => _viewType;

  void toggleView() {
    _viewType = switch (_viewType) {
      BookkeepingViewType.detailed => BookkeepingViewType.focused_visits,
      BookkeepingViewType.focused_visits => BookkeepingViewType.focused_others,
      BookkeepingViewType.focused_others => BookkeepingViewType.detailed,
    };
    notifyListeners();
  }

  final Map<String, double> _foldedVisitsBookkeeping = {};
  Map<String, double> get foldedVisitsBookkeeping => _foldedVisitsBookkeeping;

  //todo: create another bookkeeping format
  final List<BookkeepingItem> _bookkeepingOthers = [];
  List<BookkeepingItem> get bookkeepingOthers => _bookkeepingOthers;

  void _foldBookKeeping() {
    if (_result != null && _result! is ApiDataResult) {
      final _data = (_result as ApiDataResult<List<BookkeepingItem>>).data;
      //todo: fold bookkeeping if has patient_id & visit_date & visit_id

      ///needed for calculations to work correctly since assigning zero negates one iteration value
      double _initialAmount = 0;

      _data.map((e) {
        ///separate visit calculations from others that are added manually
        final bool _foldable =
            e.patient_id.isNotEmpty &&
            e.visit_date != null &&
            e.patient != null &&
            e.visit_id.isNotEmpty;
        if (_foldable) {
          final _key =
              '${e.patient_id}::${e.visit_id}::${DateFormat('dd-MM-yyyy').format(e.visit_date!)}';
          _initialAmount = e.amount;
          if (_foldedVisitsBookkeeping[_key] == null) {
            _foldedVisitsBookkeeping[_key] = _initialAmount;
          } else {
            _foldedVisitsBookkeeping[_key] =
                _foldedVisitsBookkeeping[_key]! + e.amount;
          }
        }
        ///other bookkeeping that is added manually
        else {
          //todo: separate other bookkeeping operations into their view
          _bookkeepingOthers.add(e);
        }
      }).toList();
      notifyListeners();
    }
  }
}

enum BookkeepingViewType {
  detailed('Detailed View', 'العمليات تفصيلا'),
  focused_visits('Visits View', 'تفاصيل الزيارات'),
  focused_others('Other Operations View', 'تفاصيل العمليات عدا الزيارات');

  final String en;
  final String ar;

  const BookkeepingViewType(
    this.en,
    this.ar,
  );
}
