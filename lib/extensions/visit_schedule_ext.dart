import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/visit_schedule.dart';
import 'package:one/providers/px_locale.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

extension FormattedVisitScheduleShift on VisitSchedule {
  String formattedShift(BuildContext context) {
    final _lx = context.read<PxLocale>();
    final _now = DateTime.now();
    final _start_time = _now.copyWith(hour: start_hour, minute: start_min);
    final _end_time = _now.copyWith(hour: end_hour, minute: end_min);
    final _formattedStart = DateFormat.jmv(_lx.lang).format(_start_time);
    final _formattedEnd = DateFormat.jmv(_lx.lang).format(_end_time);

    return '${context.loc.from} : $_formattedStart - ${context.loc.to} : $_formattedEnd';
  }
}
