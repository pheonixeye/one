import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/models/app_constants/_app_constants.dart';
import 'package:one/models/bookkeeping/bookkeeping_item_dto.dart';
import 'package:one/models/doctor.dart';
import 'package:one/models/visits/concised_visit.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

class ExcelFilePrep {
  final List<ConcisedVisit> visits;
  final DateTime from;
  final DateTime to;
  ExcelFilePrep({required this.visits, required this.from, required this.to}) {
    _initSheet();
  }

  final visits_sheet = 'visits';

  static const List<String> _columns = [
    'مسلسل',
    "تاريخ الزيارة",
    "اسم المريض",
    "موبايل",
    "الطبيب المعالج",
    "نوع الزيارة",
    "حالة الزيارة",
    "مسئول التسجيل",
    "اجمالي المدفوع",
  ];

  late final Excel _excel = Excel.createExcel();
  late final Sheet _visitsSheet = _excel[visits_sheet];

  void _initSheet() {
    //delete default sheet
    _excel.delete('Sheet1');
    //set is arabic
    _visitsSheet.isRTL = true;
    _excel.setDefaultSheet(visits_sheet);
    _visitsSheet.setDefaultColumnWidth(15);
    //insert columns
    for (var i = 0; i < _columns.length; i++) {
      _visitsSheet.insertColumn(i);
    }

    //insert header row
    _visitsSheet.appendRow([..._columns.map((e) => TextCellValue(e))]);
  }

  Future<void> _appendVisits(
    AppConstants constants,
    List<Doctor> doctors,
  ) async {
    final _data = await _fetchNonZeroBookKeepingOfDuration(from: from, to: to);
    await Future.delayed(const Duration(seconds: 1));
    for (final visit in visits) {
      final _visitIndex = visits.indexOf(visit);
      final _amount = _calculateVisitBookkeepingEntries(visit.id, _data);
      final _visit_status = constants.visitStatus.firstWhereOrNull(
        (e) => e.id == visit.visit_status_id,
      );
      final _visit_type = constants.visitType.firstWhereOrNull(
        (e) => e.id == visit.visit_type_id,
      );
      final _doctor = doctors.firstWhereOrNull((e) => e.id == visit.doc_id);
      _visitsSheet.appendRow([
        ..._columns.map((e) {
          final _columnIndex = _columns.indexOf(e);
          return switch (_columnIndex) {
            0 => TextCellValue('${_visitIndex + 1}'),
            1 => TextCellValue(
              DateFormat(
                'dd - MM - yyyy',
                'ar',
              ).format(DateTime.parse(visit.visit_date)),
            ),
            2 => TextCellValue(visit.patient.name),
            3 => TextCellValue(visit.patient.phone),
            4 => TextCellValue(_doctor?.name_ar ?? ''),
            5 => TextCellValue(_visit_type?.name_ar ?? ''),
            6 => TextCellValue(_visit_status?.name_ar ?? ''),
            7 => TextCellValue(visit.added_by.name),
            8 => TextCellValue(_amount.toString()),
            _ => TextCellValue(''),
          };
        }),
      ]);
    }
    _visitsSheet.setColumnWidth(0, 8);
    _visitsSheet.setColumnWidth(2, 30);
    _visitsSheet.setColumnWidth(7, 30);

    for (var i = 0; i < _columns.length; i++) {
      for (var j = 0; j < visits.length + 1; j++) {
        _visitsSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: j))
            .cellStyle = CellStyle(
          horizontalAlign: HorizontalAlign.Center,
        );
      }
    }
  }

  Future<List<int>?> save({
    required AppConstants constants,
    required List<Doctor> doctors,
  }) async {
    await _appendVisits(constants, doctors);
    return _excel.save(
      fileName:
          '${DateFormat('dd_MM_yyyy__hh__mm', 'en').format(DateTime.now())}.xlsx',
    );
  }

  Future<List<BookkeepingItemDto>> _fetchNonZeroBookKeepingOfDuration({
    required DateTime from,
    required DateTime to,
  }) async {
    final _api = BookkeepingApi();
    final _result = await _api.fetchNonZeroBookkeepingOfDuration(
      from: from,
      to: to,
    );
    return (_result as ApiDataResult<List<BookkeepingItemDto>>).data;
  }

  double _calculateVisitBookkeepingEntries(
    String visit_id,
    List<BookkeepingItemDto> data,
  ) {
    final _visitItems = data.where((e) => e.item_id == visit_id).toList();

    final _result = _visitItems
        .map((e) => e.amount)
        .toList()
        .fold<double>(0, (a, b) => a + b);

    return _result;
  }
}
