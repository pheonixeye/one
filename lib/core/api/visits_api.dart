import 'package:one/core/api/notifications_api.dart';
import 'package:one/models/notifications/notification_request.dart';
import 'package:one/models/shift.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/logic/bookkeeping_transformer.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/visit_data/visit_data_dto.dart';
import 'package:one/models/visits/_visit.dart';
import 'package:one/models/visits/visit_create_dto.dart';

class VisitsApi {
  VisitsApi();

  static const String collection = 'visits';

  static const String visit_data_collection = 'visit__data';

  static const String visit_schedule_collection = 'visit__schedule';

  static final String _expand =
      'patient_id, clinic_id, added_by_id, added_by_id.account_type_id, added_by_id.app_permissions_ids, visit_status_id, visit_type_id, patient_progress_status_id, doc_id, doc_id.speciality_id, visit_schedule_id';

  final _now = DateTime.now();

  Future<ApiResult<List<Visit>>> fetctVisitsOfASpecificDate({
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
      final _result = await PocketbaseHelper.pbBase
          .collection(collection)
          .getList(
            page: page,
            perPage: perPage,
            filter:
                "visit_date >= '$_dateOfVisitFormatted' && visit_date <= '$_dateAfterVisitFormatted'",
            expand: _expand,
            sort: '-patient_entry_number',
          );

      // prettyPrint(_result);

      final _visits = _result.items.map((e) {
        return Visit.fromRecordModel(e);
      }).toList();

      return ApiDataResult<List<Visit>>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> addNewVisit(VisitCreateDto dto) async {
    //TODO: error prone logic - multiple requests can fail;
    //create visit reference
    final _result = await PocketbaseHelper.pbBase
        .collection(collection)
        .create(body: dto.toJson(), expand: _expand);

    //create visit_data reference
    await PocketbaseHelper.pbBase
        .collection(visit_data_collection)
        .create(
          body: VisitDataDto.initial(
            visit_id: _result.id,
            patient_id: dto.patient_id,
            clinic_id: dto.clinic_id,
          ).toJson(),
        );

    //modify visit_schedule reference with visit_id
    final _visitSchedule = dto.visit_schedule.copyWith(visit_id: _result.id);

    //create visit_schedule reference
    final visit_schedule = await PocketbaseHelper.pbBase
        .collection(visit_schedule_collection)
        .create(body: _visitSchedule.toJson());
    //update visit with visit_schedule id
    final _updatedResult = await PocketbaseHelper.pbBase
        .collection(collection)
        .update(
          _result.id,
          body: {'visit_schedule_id': visit_schedule.id},
          expand: _expand,
        );

    //todo: parse result
    final _visit = Visit.fromRecordModel(_updatedResult);

    //todo: send inclinic notification
    final _notificationRequest = NotificationRequest.fromVisit(_visit);

    await NotificationsApi().sendNotification(
      // topic: _notificationRequest.topic,
      request: _notificationRequest,
    );

    //todo: initialize transformer
    final _bk_transformer = BookkeepingTransformer(
      item_id: _visit.id,
      collection_id: collection,
    );

    //todo: initialize bk_item
    final _item = _bk_transformer.fromVisitCreate(_visit);

    //todo: send bookkeeping request
    await BookkeepingApi().addBookkeepingItem(_item);
  }

  Future<void> updateVisit(Visit visit, String key, dynamic value) async {
    final _response = await PocketbaseHelper.pbBase
        .collection(collection)
        .update(visit.id, body: {key: value}, expand: _expand);

    //todo: parse result
    final _old_visit = visit;
    final _updated_visit = Visit.fromRecordModel(_response);

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

  Future<ApiResult<List<Visit>>> fetctVisitsOfOneMonth({
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
      final _result = await PocketbaseHelper.pbBase
          .collection(collection)
          .getFullList(
            filter:
                "visit_date >= '$_formatted_month_date' && visit_date <= '$_formatted_month_plus_date'",
            expand: _expand,
          );

      final _visits = _result.map((e) {
        return Visit.fromRecordModel(e);
      }).toList();

      return ApiDataResult<List<Visit>>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
  //todo: add update visit schedule function

  Future<void> updateVisitScheduleShift({
    required String visit_shift_id,
    required Shift shift,
  }) async {
    await PocketbaseHelper.pbBase
        .collection(visit_schedule_collection)
        .update(visit_shift_id, body: shift.toJson());
  }
}


// Future<UnsubscribeFunc> todayVisitsSubscription(
  //   void Function(RecordSubscriptionEvent) callback,
  // ) async {
  //   final visit_date = _now;
  //   final _date_of_visit =
  //       DateTime(visit_date.year, visit_date.month, visit_date.day);
  //   final _date_after_visit =
  //       DateTime(visit_date.year, visit_date.month, visit_date.day + 1);

  //   final _dateOfVisitFormatted =
  //       DateFormat('yyyy-MM-dd', 'en').format(_date_of_visit);
  //   final _dateAfterVisitFormatted =
  //       DateFormat('yyyy-MM-dd', 'en').format(_date_after_visit);

  //   final sub = await PocketbaseHelper.pb.collection(collection).subscribe(
  //         '*',
  //         callback,
  //         filter:
  //             "visit_date >= '$_dateOfVisitFormatted' && visit_date < '$_dateAfterVisitFormatted'",
  //         expand: _expand,
  //       );
  //   return sub;
  // }