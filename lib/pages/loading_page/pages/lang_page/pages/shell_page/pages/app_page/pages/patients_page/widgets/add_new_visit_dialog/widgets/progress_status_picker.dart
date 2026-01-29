import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/app_constants/patient_progress_status.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class ProgressStatusPicker extends StatelessWidget {
  const ProgressStatusPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAddNewVisitDialog, PxAppConstants, PxLocale>(
      builder: (context, s, a, l, _) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.pickPatientProgressStatus),
          ),
          subtitle: FormField<PatientProgressStatus>(
            builder: (field) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioGroup<PatientProgressStatus>(
                  groupValue: s.patientProgressStatus,
                  onChanged: (value) {
                    s.selectProgressStatus(value);
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      ...a.constants!.patientProgressStatus.map((e) {
                        bool _isSelected = e == s.patientProgressStatus;
                        return RadioListTile<PatientProgressStatus>(
                          shape: s.tileBorder(_isSelected),
                          selected: _isSelected,
                          tileColor: s.unSelectedColor,
                          selectedTileColor: s.selectedColor,
                          title: Text(
                            l.isEnglish ? e.name_en : e.name_ar,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: e,
                        );
                      }),
                      s.validationErrorWidget(field),
                    ],
                  ),
                ),
              );
            },
            validator: (value) {
              if (s.patientProgressStatus == null) {
                return context.loc.pickPatientProgressStatus;
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
