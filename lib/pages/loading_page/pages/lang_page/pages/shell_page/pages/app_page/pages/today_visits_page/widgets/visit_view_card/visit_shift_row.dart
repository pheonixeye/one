import 'package:one/core/api/visits_api.dart';
import 'package:one/core/logic/client_notification_formatter_sender.dart';
import 'package:one/extensions/clinic_schedule_shift_ext.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/visit_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/models/notifications/in_app_action.dart';
import 'package:one/models/shift.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/reschedule_visit_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/providers/px_visits_per_clinic_shift.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisitShiftRow extends StatelessWidget {
  const VisitShiftRow({super.key, required this.visit});
  final VisitExpanded visit;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: const Icon(Icons.more_time_rounded),
        ),
        Expanded(
          flex: 3,
          child: ElevatedButton(
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_TodayVisits_Reschedule_Visit,
                context,
              );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(permission: _perm.permission);
                  },
                );
                return;
              }
              final _shift = await showDialog<ScheduleShift?>(
                context: context,
                builder: (context) {
                  return ChangeNotifierProvider(
                    create: (context) => PxVisitsPerClinicShift(
                      visit_date: visit.visit_date,
                      clinic_id: visit.clinic_id,
                      api: VisitsApi(
                        added_by: '${context.read<PxAuth>().user?.name}',
                      ),
                    ),
                    child: RescheduleVisitDialog(visit: visit),
                  );
                },
              );
              if (_shift == null) {
                return;
              }
              final _clinicSchedule = visit.clinic.clinic_schedule.firstWhere(
                (sch) => sch.intday == visit.intday,
              );

              if (visit.isInSameShift(_clinicSchedule, _shift)) {
                if (context.mounted) {
                  showIsnackbar(context.loc.sameShiftSelected);
                }
                return;
              }

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await context.read<PxVisits>().updateVisitScheduleShift(
                      visit_id: visit.id,
                      shift: Shift.fromScheduleShift(_shift),
                    );
                    //todo: Notify FCM to Org Members visit Shift changed
                    if (context.mounted) {
                      ClientNotificationFormatterSender(
                          organizationExpanded: context
                              .read<PxAuth>()
                              .organization!,
                          isEnglish: context.read<PxLocale>().isEnglish,
                        )
                        ..formatFromInAppAction(
                          action: InAppAction.update_visit_shift,
                          account_types:
                              context
                                  .read<PxAppConstants>()
                                  .constants
                                  ?.accountTypes ??
                              [],
                          visit_date: visit.visit_date,
                          patient_name: visit.patient.name,
                          doctor_name: visit.doctor.name_en,
                          visit_shift: visit.formattedShift(context),
                          new_visit_shift: _shift.formattedFromTo(context),
                        )
                        ..send();
                    }
                  },
                );
              }
            },
            child: Text(visit.formattedShift(context)),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
