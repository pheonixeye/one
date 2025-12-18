import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

extension WxClinicScheduleSHift on ScheduleShift {
  String formattedFromTo(BuildContext context) {
    final l = context.read<PxLocale>();
    final isEnglish = l.isEnglish;
    final startTime = DateTime.now().copyWith(
      hour: start_hour,
      minute: start_min,
    );
    final endTime = DateTime.now().copyWith(hour: end_hour, minute: end_min);
    return isEnglish
        ? 'From : ${DateFormat.jm(l.lang).format(startTime)} - To : ${DateFormat.jm(l.lang).format(endTime)}'
        : 'من : ${DateFormat.jm(l.lang).format(startTime)} - الي : ${DateFormat.jm(l.lang).format(endTime)}';
  }
}
