import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/app_constants/visit_status.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class VisitStatusPicker extends StatelessWidget {
  const VisitStatusPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAddNewVisitDialog, PxAppConstants, PxLocale>(
      builder: (context, s, a, l, _) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.pickVisitStatus),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormField(
              validator: (value) {
                if (s.visitStatus == null) {
                  return context.loc.pickVisitStatus;
                }
                return null;
              },
              builder: (field) {
                return RadioGroup<VisitStatus>(
                  groupValue: s.visitStatus,
                  onChanged: (value) {
                    s.selectVisitStatus(value);
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      ...a.constants!.visitStatus.map((e) {
                        bool _isSelected = e == s.visitStatus;
                        return RadioListTile<VisitStatus>(
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}
