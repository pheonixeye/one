import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class VisitTypePicker extends StatelessWidget {
  const VisitTypePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAddNewVisitDialog, PxAppConstants, PxLocale>(
      builder: (context, s, a, l, _) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.pickVisitType),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormField<VisitType>(
              validator: (value) {
                if (s.visitType == null) {
                  return context.loc.pickVisitType;
                }
                return null;
              },
              builder: (field) {
                return RadioGroup<VisitType>(
                  groupValue: s.visitType,
                  onChanged: (value) {
                    s.selectVisitType(value);
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      ...a.constants!.visitType.map((e) {
                        bool _isSelected = e == s.visitType;
                        return RadioListTile<VisitType>(
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
