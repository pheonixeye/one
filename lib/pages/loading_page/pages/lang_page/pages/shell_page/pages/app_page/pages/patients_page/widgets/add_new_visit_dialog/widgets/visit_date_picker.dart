import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class VisitDatePicker extends StatelessWidget {
  const VisitDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAddNewVisitDialog, PxVisits, PxLocale>(
      builder: (context, s, v, l, _) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.pickVisitDate),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    enabled: false,
                    controller: s.visitDateController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.loc.pickVisitDate;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: SmBtn(
                    onPressed: () async {
                      final _vd = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().copyWith(
                          year: DateTime.now().year + 1,
                        ),
                        selectableDayPredicate: (day) {
                          if (day.weekday == s.clinicSchedule!.intday) {
                            return true;
                          }
                          return false;
                        },
                      );
                      if (_vd == null) {
                        return;
                      }
                      s.visitDateController.text = DateFormat(
                        'dd / MM / yyyy',
                        l.lang,
                      ).format(_vd);
                      s.selectVisitDate(_vd);

                      if (s.clinic != null && s.visitDate != null) {
                        await v.calculateVisitsPerClinicShift(
                          s.clinic!.id,
                          s.visitDate!,
                        );
                      }
                    },
                    child: const Icon(Icons.calendar_month),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
