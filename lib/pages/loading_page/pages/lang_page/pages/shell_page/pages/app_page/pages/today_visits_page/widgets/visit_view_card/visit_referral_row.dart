import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/doctor_items/doctor_referral_item.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_doctor_profile_items.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:provider/provider.dart';

class VisitReferralRow extends StatelessWidget {
  const VisitReferralRow({super.key, required this.visit});
  final VisitExpanded visit;

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      PxDoctorProfileItems<DoctorReferralItem>,
      PxVisits,
      PxLocale
    >(
      builder: (context, p, v, l, _) {
        while (p.data == null) {
          return const SizedBox(
            height: 10,
            child: LinearProgressIndicator(),
          );
        }
        final _refs = (p.data as ApiDataResult<List<DoctorReferralItem>>).data;

        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: const Icon(Icons.queue_play_next),
            ),
            Expanded(
              child: Text(context.loc.referredFrom),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: PopupMenuButton<void>(
                offset: Offset(0, 48),
                elevation: 6,
                shadowColor: Colors.transparent,
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(),
                ),
                itemBuilder: (context) {
                  return [
                    ..._refs.map((e) {
                      final _enabled = e.id != visit.referral.id;
                      return PopupMenuItem(
                        mouseCursor: _enabled
                            ? SystemMouseCursors.click
                            : SystemMouseCursors.forbidden,
                        enabled: _enabled,
                        child: Center(
                          child: Card.outlined(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                8.0,
                              ),
                              child: Text(
                                l.isEnglish ? e.name_en : e.name_ar,
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              //@permission
                              final _perm = context
                                  .read<PxAuth>()
                                  .isActionPermitted(
                                    PermissionEnum
                                        .User_TodayVisits_Modify_Attendance,
                                    context,
                                  );
                              if (!_perm.isAllowed) {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NotPermittedDialog(
                                      permission: _perm.permission,
                                    );
                                  },
                                );
                                return;
                              }
                              await v.updateVisit(
                                visit: visit,
                                key: 'visit_status',
                                value: e.name_en,
                              );
                            },
                          );
                        },
                      );
                    }),
                  ];
                },
                child: Card.outlined(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      l.isEnglish
                          ? visit.referral.name_en
                          : visit.referral.name_ar,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
