import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class ClinicPicker extends StatelessWidget {
  const ClinicPicker({super.key, required this.clinics});
  final List<Clinic> clinics;

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxAddNewVisitDialog, PxLocale>(
      builder: (context, s, l, _) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.pickClinic),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormField<Clinic>(
              builder: (field) {
                return RadioGroup<Clinic>(
                  groupValue: s.clinic,
                  onChanged: (value) {
                    s.selectClinic(value);
                    s.selectClinicSchedule(null);
                    s.selectScheduleShift(null);
                    s.selectVisitDate(null);
                    s.visitDateController.clear();
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      ...clinics.map((e) {
                        bool _isSelected = e == s.clinic;
                        return RadioListTile<Clinic>(
                          shape: s.tileBorder(_isSelected),
                          selected: _isSelected,
                          enabled: e.is_active,
                          tileColor: s.unSelectedColor,
                          selectedTileColor: s.selectedColor,
                          title: Text(
                            l.isEnglish ? e.name_en : e.name_ar,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: e,
                        );
                      }),
                      s.validationErrorWidget<Clinic>(field),
                    ],
                  ),
                );
              },
              validator: (value) {
                if (s.clinic == null) {
                  return context.loc.pickClinic;
                }
                return null;
              },
            ),
          ),
        );
      },
    );
  }
}
