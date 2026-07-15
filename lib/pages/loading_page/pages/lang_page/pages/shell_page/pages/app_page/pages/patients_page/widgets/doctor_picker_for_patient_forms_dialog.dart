import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class DoctorPickerForPatientFormsDialog extends StatelessWidget {
  DoctorPickerForPatientFormsDialog({super.key});

  final ValueNotifier<Doctor?> _docNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(context.loc.pickDoctor),
          ),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      scrollable: true,
      content: Consumer2<PxDoctor, PxLocale>(
        builder: (context, d, l, _) {
          while (d.allDoctors == null) {
            return const CentralLoading();
          }
          while (d.allDoctors != null && d.allDoctors!.isEmpty) {
            return CentralNoItems(
              message: context.loc.noDoctorsFound,
            );
          }
          final _doctors = d.allDoctors;
          return ValueListenableBuilder<Doctor?>(
            valueListenable: _docNotifier,
            builder: (context, value, child) {
              return RadioGroup<Doctor>(
                groupValue: _docNotifier.value,
                onChanged: (value) {
                  _docNotifier.value = value;
                  if (value != null) {
                    Navigator.pop(context, value.id);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_doctors != null)
                      ..._doctors.map((doc) {
                        return RadioListTile<Doctor>(
                          selected: _docNotifier.value == doc,
                          value: doc,
                          title: Text(
                            l.isEnglish ? doc.name_en : doc.name_ar,
                          ),
                        );
                      }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
