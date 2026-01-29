import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class DoctorPicker extends StatelessWidget {
  const DoctorPicker({super.key, required this.doctors});
  final List<Doctor> doctors;

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxAddNewVisitDialog, PxLocale>(
      builder: (context, s, l, _) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.pickDoctor),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormField<Doctor>(
              builder: (field) {
                return RadioGroup<Doctor>(
                  groupValue: s.doctor,
                  onChanged: (value) {
                    s.selectDoctor(value);
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      if (s.clinic != null)
                        ...doctors
                            .where((d) => s.clinic!.doc_id.contains(d.id))
                            .map((e) {
                              bool _isSelected = e == s.doctor;
                              return RadioListTile<Doctor>(
                                shape: s.tileBorder(_isSelected),
                                selected: _isSelected,
                                tileColor: s.unSelectedColor,
                                selectedTileColor: s.selectedColor,
                                title: Text(
                                  l.isEnglish ? e.name_en : e.name_ar,
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: e,
                              );
                            }),
                      s.validationErrorWidget<Doctor>(field),
                    ],
                  ),
                );
              },
              validator: (value) {
                if (s.doctor == null) {
                  return context.loc.pickDoctor;
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
