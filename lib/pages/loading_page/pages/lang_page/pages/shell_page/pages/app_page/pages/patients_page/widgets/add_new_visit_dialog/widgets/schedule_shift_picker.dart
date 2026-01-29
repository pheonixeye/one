import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/clinic_schedule_shift_ext.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/models/shift.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:provider/provider.dart';

class ScheduleShiftPicker extends StatelessWidget {
  const ScheduleShiftPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAddNewVisitDialog, PxVisits, PxLocale>(
      builder: (context, s, v, l, _) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.pickClinicScheduleShift),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormField<ScheduleShift>(
              validator: (value) {
                if (s.scheduleShift == null) {
                  return context.loc.pickClinicScheduleShift;
                }
                return null;
              },
              builder: (field) {
                return RadioGroup<ScheduleShift>(
                  groupValue: s.scheduleShift,
                  onChanged: (value) {
                    s.selectScheduleShift(value);
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      if (s.clinicSchedule != null)
                        ...s.clinicSchedule!.shifts.map((e) {
                          final _shift = Shift.fromScheduleShift(e);
                          //todo: disable tile if _isDisabled
                          bool _isSelected = e == s.scheduleShift;
                          bool _isDisabled =
                              (v.visitsPerShift?[_shift] != null &&
                              v.visitsPerShift![_shift]! >= e.visit_count);

                          return RadioListTile<ScheduleShift>(
                            shape: s.tileBorder(_isSelected),
                            selected: _isSelected,
                            tileColor: s.unSelectedColor,
                            selectedTileColor: s.selectedColor,
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e.formattedFromTo(context),
                                    style: !_isDisabled
                                        ? null
                                        : TextStyle(
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                  ),
                                ),
                                if (s.visitDate != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Tooltip(
                                      message: context.loc.dayVisitCount,
                                      child: v.isUpdating
                                          ? CupertinoActivityIndicator()
                                          : Text.rich(
                                              TextSpan(
                                                text: '',
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${v.visitsPerShift?[_shift] ?? '0'} ${_isSelected ? '+ 1' : ''}'
                                                            .toArabicNumber(
                                                              context,
                                                            ),
                                                    style: TextStyle(
                                                      color: _isDisabled
                                                          ? Colors.red
                                                          : Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' / ',
                                                  ),
                                                  TextSpan(
                                                    text: '${e.visit_count}'
                                                        .toArabicNumber(
                                                          context,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                              ],
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: e,
                          );
                        }),
                      s.validationErrorWidget(field),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
