import 'dart:async';

import 'package:intl/intl.dart';
import 'package:one/annotations/pb_annotations.dart';
import 'package:one/models/visits/visit.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';

@PbData()
class TodayPatientProgressApi {
  final String doc_id;
  final String clinic_id;
  late final DateTime _date;

  late final _date_of_visit = DateTime(_date.year, _date.month, _date.day);
  late final _date_after_visit = DateTime(
    _date.year,
    _date.month,
    _date.day + 1,
  );

  static const String _expand = 'doc_id, clinic_id, patient_id';

  late final _dateOfVisitFormatted = DateFormat(
    'yyyy-MM-dd',
    'en',
  ).format(_date_of_visit);
  late final _dateAfterVisitFormatted = DateFormat(
    'yyyy-MM-dd',
    'en',
  ).format(_date_after_visit);

  TodayPatientProgressApi({
    required this.doc_id,
    required this.clinic_id,
    DateTime? date,
  }) {
    _date = date ?? DateTime.now();
  }

  late final collection = 'visits';

  Future<UnsubscribeFunc> listenToVisitsCollectionStream(
    void Function(RecordSubscriptionEvent) callback,
  ) async {
    return await PocketbaseHelper.pbData
        .collection(collection)
        .subscribe(
          '*',
          callback,
          filter:
              "visit_date >= '$_dateOfVisitFormatted' && visit_date <= '$_dateAfterVisitFormatted'",
          expand: _expand,
        );
  }

  Future<List<VisitExpanded>> fetchTodayVisits() async {
    final _response = await PocketbaseHelper.pbData
        .collection(collection)
        .getFullList(
          filter:
              "visit_date >= '$_dateOfVisitFormatted' && visit_date <= '$_dateAfterVisitFormatted'",
          sort: '-patient_entry_number',
          expand: _expand,
        );

    return _response.map((e) => VisitExpanded.fromRecordModel(e)).toList();
  }
}
