import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/doctor_referral_item.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_doctor_profile_items.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class ReferralPicker extends StatelessWidget {
  const ReferralPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      PxAddNewVisitDialog,
      PxDoctorProfileItems<DoctorReferralItem>,
      PxLocale
    >(
      builder: (context, s, p, l, _) {
        while (p.data == null) {
          return const SizedBox(
            height: 10,
            child: LinearProgressIndicator(),
          );
        }
        while (p.data is ApiErrorResult) {
          return SizedBox(
            height: 40,
            child: Text(context.loc.error),
          );
        }
        final _items = (p.data as ApiDataResult<List<DoctorReferralItem>>).data;
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.pickReferral),
          ),
          subtitle: FormField<DoctorReferralItem>(
            builder: (field) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioGroup<DoctorReferralItem>(
                  groupValue: s.referral,
                  onChanged: (value) {
                    s.selectReferral(value);
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      ..._items.map((e) {
                        bool _isSelected = e.id == s.referral?.id;
                        return RadioListTile<DoctorReferralItem>(
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
              if (s.referral == null) {
                return context.loc.pickReferral;
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
