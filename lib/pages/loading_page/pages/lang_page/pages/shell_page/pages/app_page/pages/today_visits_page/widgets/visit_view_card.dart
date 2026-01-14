import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/discount_managment_row.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/visit_shift_row.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/extensions/visit_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:provider/provider.dart';

class VisitViewCard extends StatelessWidget {
  const VisitViewCard({super.key, required this.visit, required this.index});
  final Visit visit;
  final int index;

  @override
  Widget build(BuildContext context) {
    //TODO: restrucutre into smaller widgets
    return Consumer3<PxAppConstants, PxVisits, PxLocale>(
      builder: (context, a, v, l, _) {
        while (a.constants == null) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Card.outlined(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 60,
                  child: Center(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: LinearProgressIndicator()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  //entry number column
                  Column(
                    spacing: 12,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () async {
                          //@permission
                          final _perm = context
                              .read<PxAuth>()
                              .isActionPermitted(
                                PermissionEnum
                                    .User_TodayVisits_Modify_Entry_Number,
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
                                key: 'patient_entry_number',
                                value: visit.patient_entry_number + 1,
                              );
                            },
                          );
                        },
                        child: Icon(Icons.arrow_drop_up),
                      ),
                      SmBtn(
                        onPressed: null,
                        child: Text(
                          '${visit.patient_entry_number}'.toArabicNumber(
                            context,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () async {
                          //@permission
                          final _perm = context
                              .read<PxAuth>()
                              .isActionPermitted(
                                PermissionEnum
                                    .User_TodayVisits_Modify_Entry_Number,
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
                          if (visit.patient_entry_number <= 1) {
                            return;
                          }
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await v.updateVisit(
                                visit: visit,
                                key: 'patient_entry_number',
                                value: visit.patient_entry_number - 1,
                              );
                            },
                          );
                        },
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                  //data & action rows
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8.0),
                      child: Column(
                        children: [
                          Row(
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
                                        final _enabled =
                                            e.name_en != visit.visit_type;
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
                                                  l.isEnglish
                                                      ? e.name_en
                                                      : e.name_ar,
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
                                                    permission:
                                                        _perm.permission,
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
                                                  key: 'visit_type_id',
                                                  value: e.id,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }),
                                    ];
                                  },
                                  child: Card.outlined(
                                    color: visit.visit_type.getCardColor,
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        l.isEnglish
                                            ? visit.visit_type.name_en
                                            : visit.visit_type.name_ar,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //visit shift row
                          VisitShiftRow(visit: visit),
                          //visit status toggle
                          Row(
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
                                        final _enabled =
                                            e.name_en != visit.visit_status;
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
                                                  l.isEnglish
                                                      ? e.name_en
                                                      : e.name_ar,
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
                                                        permission:
                                                            _perm.permission,
                                                      );
                                                    },
                                                  );
                                                  return;
                                                }
                                                await v.updateVisit(
                                                  visit: visit,
                                                  key: 'visit_status_id',
                                                  value: e.id,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }),
                                    ];
                                  },
                                  child: Card.outlined(
                                    color: visit.visit_status.getCardColor,
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        l.isEnglish
                                            ? visit.visit_status.name_en
                                            : visit.visit_status.name_ar,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              //patient progress status toogle
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: const Icon(Icons.add_task_outlined),
                              ),
                              Expanded(child: Text(context.loc.progressStatus)),
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
                                      ...a.patientProgressStatuses.map((e) {
                                        final _enabled =
                                            e.name_en !=
                                            visit.patient_progress_status;
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
                                                  l.isEnglish
                                                      ? e.name_en
                                                      : e.name_ar,
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
                                                      .User_TodayVisits_Modify_Visit_Progress,
                                                  context,
                                                );
                                            if (!_perm.isAllowed) {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return NotPermittedDialog(
                                                    permission:
                                                        _perm.permission,
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
                                                  key:
                                                      'patient_progress_status_id',
                                                  value: e.id,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }),
                                    ];
                                  },
                                  child: Card.outlined(
                                    color: visit
                                        .patient_progress_status
                                        .getCardColor,
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        l.isEnglish
                                            ? visit
                                                  .patient_progress_status
                                                  .name_en
                                            : visit
                                                  .patient_progress_status
                                                  .name_ar,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //discount managment row
                          DiscountManagmentRow(visit: visit),
                        ],
                      ),
                    ),
                  ),
                  //enter details page
                  Column(
                    children: [
                      SmBtn(
                        onPressed: () async {
                          //@permission
                          final _perm = context
                              .read<PxAuth>()
                              .isActionPermitted(PermissionEnum.Admin, context);
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
                          if (visit.visit_status == a.notAttended.name_en) {
                            showIsnackbar(context.loc.visitNotAttended);
                            return;
                          }
                          GoRouter.of(context).goNamed(
                            AppRouter.visit_forms,
                            pathParameters: defaultPathParameters(context)
                              ..addAll({'visit_id': visit.id}),
                            extra: visit.patient_id,
                          );
                        },
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
