import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/pi_referral.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_referrals.dart';
import 'package:provider/provider.dart';

class ReferralPicker extends StatelessWidget {
  const ReferralPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAddNewVisitDialog, PxPiReferrals, PxLocale>(
      builder: (context, s, r, l, _) {
        while (r.referrals == null) {
          return const SizedBox(
            height: 10,
            child: LinearProgressIndicator(),
          );
        }
        while (r.referrals is ApiErrorResult) {
          return SizedBox(
            height: 40,
            child: Text(context.loc.error),
          );
        }
        final _items = (r.referrals as ApiDataResult<List<PiReferral>>).data;
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.pickReferral),
          ),
          subtitle: FormField<PiReferral>(
            builder: (field) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioGroup<PiReferral>(
                  groupValue: s.referral,
                  onChanged: (value) {
                    s.selectReferral(value);
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      ..._items.map((e) {
                        bool _isSelected = e.id == s.referral?.id;
                        return RadioListTile<PiReferral>(
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
