import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/clinic/clinic_schedule.dart';
import 'package:one/models/weekdays.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:provider/provider.dart';

class ClinicSchedulePicker extends StatelessWidget {
  const ClinicSchedulePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAddNewVisitDialog, PxVisits, PxLocale>(
      builder: (context, s, v, l, _) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.pickClinicSchedule),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormField<ClinicSchedule>(
              validator: (value) {
                if (s.clinicSchedule == null) {
                  return context.loc.pickClinicSchedule;
                }
                return null;
              },
              builder: (field) {
                return RadioGroup<ClinicSchedule>(
                  groupValue: s.clinicSchedule,
                  onChanged: (value) async {
                    s.selectClinicSchedule(value);
                    s.selectScheduleShift(null);
                    s.selectVisitDate(null);
                    s.visitDateController.clear();

                    if (s.clinic != null && s.visitDate != null) {
                      await v.calculateVisitsPerClinicShift(
                        s.clinic!.id,
                        s.visitDate!,
                      );
                    }
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      ...s.clinic!.clinic_schedule.map((e) {
                        bool _isSelected = e == s.clinicSchedule;
                        return RadioListTile<ClinicSchedule>(
                          shape: s.tileBorder(_isSelected),
                          selected: _isSelected,
                          tileColor: s.unSelectedColor,
                          selectedTileColor: s.selectedColor,
                          title: Text(
                            l.isEnglish
                                ? Weekdays.getWeekday(e.intday).en
                                : Weekdays.getWeekday(e.intday).ar,
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
