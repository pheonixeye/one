import 'package:flutter/material.dart';
import 'package:one/core/logic/client_notification_formatter_sender.dart';
import 'package:one/extensions/visit_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/models/notifications/in_app_action.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:provider/provider.dart';

class VisitTypeRow extends StatelessWidget {
  const VisitTypeRow({super.key, required this.visit});
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
              child: const Icon(Icons.person),
            ),
            Expanded(
              child: Text(
                visit.patient.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (visit.comments.isNotEmpty)
              Tooltip(
                message: visit.comments,
                child: Icon(
                  Icons.info,
                  size: 14,
                  color: Colors.amber,
                ),
              ),
            //visit type toggle
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
                    ...a.visitTypes.map((e) {
                      final _enabled = e.name_en != visit.visit_type;
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
                          //@permission
                          final _perm = context
                              .read<PxAuth>()
                              .isActionPermitted(
                                PermissionEnum
                                    .User_TodayVisits_Modify_Visit_Type,
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
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await v.updateVisit(
                                visit: visit,
                                key: 'visit_type',
                                value: e.name_en,
                              );
                              if (context.mounted) {
                                //todo: Notify FCM to Org Members visit Type Changed
                                ClientNotificationFormatterSender(
                                    organizationExpanded: context
                                        .read<PxAuth>()
                                        .organization!,
                                    isEnglish: l.isEnglish,
                                  )
                                  ..formatFromInAppAction(
                                    action: InAppAction.update_visit_type,
                                    account_types:
                                        context
                                            .read<PxAppConstants>()
                                            .constants
                                            ?.accountTypes ??
                                        [],
                                    visit_date: visit.visit_date,
                                    visit_type: visit.visit_type,
                                    new_visit_type: e.name_en,
                                    patient_name: visit.patient.name,
                                    doctor_name: visit.doctor.name_en,
                                  )
                                  ..send();
                              }
                            },
                          );
                        },
                      );
                    }),
                  ];
                },
                child: Card.outlined(
                  color: VisitTypeEnum.member(
                    visit.visit_type,
                  ).getCardColor,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      VisitTypeEnum.visitType(
                        visit.visit_type,
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
