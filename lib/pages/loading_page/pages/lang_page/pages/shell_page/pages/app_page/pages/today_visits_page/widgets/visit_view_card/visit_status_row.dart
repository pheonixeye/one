import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/visit_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/app_constants/visit_status.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:provider/provider.dart';

class VisitStatusRow extends StatelessWidget {
  const VisitStatusRow({super.key, required this.visit});
  final VisitExpanded visit;
  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxVisits, PxLocale>(
      builder: (context, a, v, l, _) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: const Icon(Icons.wash_rounded),
            ),
            Expanded(
              child: Text(context.loc.attendanceStatus),
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
                    ...a.visitStatuses.map((e) {
                      final _enabled = e.name_en != visit.visit_status;
                      return PopupMenuItem(
                        mouseCursor: _enabled
                            ? SystemMouseCursors.click
                            : SystemMouseCursors.forbidden,
                        enabled: _enabled,
                        child: Center(
                          child: Card.outlined(
                            color: e.getCardColor,
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
                              //TODO: Notify FCM to Org Members visit Status changed
                            },
                          );
                        },
                      );
                    }),
                  ];
                },
                child: Card.outlined(
                  color: VisitStatusEnum.member(
                    visit.visit_status,
                  ).getCardColor,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      VisitStatusEnum.visitStatus(
                        visit.visit_status,
                        l.isEnglish,
                      ),
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
