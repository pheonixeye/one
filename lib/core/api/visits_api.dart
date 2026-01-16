import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/notifications_api.dart';
import 'package:one/models/notifications/notification_request.dart';
import 'package:intl/intl.dart';
import 'package:one/models/shift.dart';
import 'package:one/models/visits/visit.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/logic/bookkeeping_transformer.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/visit_data/visit_data_dto.dart';

@PbData()
class VisitsApi {
  VisitsApi();

  static const String collection = 'visits';

  static const String visit_data_collection = 'visit__data';

  static const String _expand = 'doc_id, clinic_id, patient_id';

  final _now = DateTime.now();

  Future<ApiResult<List<VisitExpanded>>> fetctVisitsOfASpecificDate({
    required int page,
    required int perPage,
    DateTime? visit_date,
  }) async {
    visit_date = visit_date ?? _now;
    final _date_of_visit = DateTime(
      visit_date.year,
      visit_date.month,
      visit_date.day,
    );
    final _date_after_visit = DateTime(
      visit_date.year,
      visit_date.month,
      visit_date.day + 1,
    );

    final _dateOfVisitFormatted = DateFormat(
      'yyyy-MM-dd',
      'en',
    ).format(_date_of_visit);
    final _dateAfterVisitFormatted = DateFormat(
      'yyyy-MM-dd',
      'en',
    ).format(_date_after_visit);
    try {
      // print(_todayFormatted);
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .getList(
            page: page,
            perPage: perPage,
            expand: _expand,
            filter:
                "visit_date >= '$_dateOfVisitFormatted' && visit_date <= '$_dateAfterVisitFormatted'",
            sort: '-patient_entry_number',
          );

      // prettyPrint(_result);

      final _visits = _result.items.map((e) {
        return VisitExpanded.fromRecordModel(e);
      }).toList();

      return ApiDataResult<List<VisitExpanded>>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> addNewVisit(Visit visit) async {
    //create visit reference
    final _result = await PocketbaseHelper.pbData
        .collection(collection)
        .create(
          body: visit.toJson(),
          expand: _expand,
        );

    //create visit_data reference
    await PocketbaseHelper.pbData
        .collection(visit_data_collection)
        .create(
          body: VisitDataDto.initial(
            doc_id: visit.doc_id,
            visit_id: _result.id,
            patient_id: visit.patient_id,
            clinic_id: visit.clinic_id,
          ).toJson(),
        );

    //todo: parse result
    final _visit = VisitExpanded.fromRecordModel(_result);

    //todo: initialize transformer
    final _bk_transformer = BookkeepingTransformer(
      item_id: _visit.id,
      collection_id: collection,
    );

    //todo: initialize bk_item
    final _item = _bk_transformer.fromVisitCreate(_visit);

    //todo: send bookkeeping request
    await BookkeepingApi().addBookkeepingItem(_item);

    //TODO: send inclinic notification

    // final _notificationRequest = NotificationRequest.fromVisit(_visit);

    // await NotificationsApi().sendNotification(
    //   request: _notificationRequest,
    // );
  }

  Future<void> updateVisit(
    VisitExpanded visit,
    String key,
    dynamic value,
  ) async {
    final _response = await PocketbaseHelper.pbData
        .collection(collection)
        .update(
          visit.id,
          body: {key: value},
          expand: _expand,
        );

    //todo: parse result
    final _old_visit = visit;
    final _updated_visit = VisitExpanded.fromRecordModel(_response);

    //todo: initialize transformer
    final _bk_transformer = BookkeepingTransformer(
      item_id: visit.id,
      collection_id: collection,
    );

    //todo: initialize bk_item
    final _item = _bk_transformer.fromVisitUpdate(_old_visit, _updated_visit);

    //todo: send bookkeeping request
    await BookkeepingApi().addBookkeepingItem(_item);
  }

  Future<ApiResult<List<VisitExpanded>>> fetctVisitsOfOneMonth({
    required int month,
    required int year,
  }) async {
    final _month_date = DateTime(year, month, 1);
    final _month_plus_date = DateTime(year, month + 1, 1);

    final _formatted_month_date = DateFormat(
      'yyyy-MM-dd',
      'en',
    ).format(_month_date);
    final _formatted_month_plus_date = DateFormat(
      'yyyy-MM-dd',
      'en',
    ).format(_month_plus_date);

    try {
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .getFullList(
            filter:
                "visit_date >= '$_formatted_month_date' && visit_date <= '$_formatted_month_plus_date'",
            expand: _expand,
          );

      final _visits = _result.map((e) {
        return VisitExpanded.fromRecordModel(e);
      }).toList();

      return ApiDataResult<List<VisitExpanded>>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> updateVisitScheduleShift({
    required String visit_id,
    required Shift shift,
  }) async {
    await PocketbaseHelper.pbData
        .collection(collection)
        .update(
          visit_id,
          body: {
            's_h': shift.start_hour,
            's_m': shift.start_min,
            'e_h': shift.end_hour,
            'e_m': shift.end_min,
          },
        );
  }
}
