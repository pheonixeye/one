import 'package:flutter/material.dart';
import 'package:one/core/api/fcm_notifications_api.dart';
import 'package:one/core/api/visits_api.dart';
import 'package:one/core/logic/client_notification_formatter_sender.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/notifications/clinic_call.dart';
import 'package:one/models/user/user.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/clinic_calls_btn/visit_select_fees_amount_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_firebase_notifications.dart';
import 'package:one/providers/px_visits.dart';
import 'package:provider/provider.dart';

class CallsLogicBtn extends StatefulWidget {
  const CallsLogicBtn({
    super.key,
    required this.auth,
    required this.assistantsWithAll,
    required this.doctors,
    required this.isEnglish,
    required this.d,
    required this.fcm,
  });
  final PxAuth auth;
  final PxDoctor d;
  final PxFirebaseNotifications fcm;
  final List<User> assistantsWithAll;
  final List<User> doctors;
  final bool isEnglish;

  @override
  State<CallsLogicBtn> createState() => _CallsLogicBtnState();
}

class _CallsLogicBtnState extends State<CallsLogicBtn> {
  late final List<PopupMenuEntry> _assistantBtns = [
    ...widget.assistantsWithAll.map((x) {
      return PopupMenuItem<void>(
        padding: const EdgeInsets.all(0),
        child: PopupMenuButton(
          offset: widget.isEnglish ? Offset(-150, 25) : Offset(150, 25),
          elevation: 6,
          borderRadius: BorderRadius.circular(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(),
          ),
          itemBuilder: (context) {
            return [
              ...DoctorClinicCall.calls.map((
                call,
              ) {
                return PopupMenuItem(
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.top,
                    leading: Icon(
                      call.iconData,
                      color: Colors.black,
                    ),
                    title: Text(
                      widget.isEnglish ? call.en : call.ar,
                    ),
                  ),
                  onTap: () async {
                    String? _fees_amount;
                    String? _patient_name;

                    if (call.type == CallEnum.collect_fees ||
                        call.type == CallEnum.return_fees) {
                      //todo: create a dialog to enter fees and select patient / visit from today's visits
                      final name_and_fees =
                          await showDialog<Map<String, dynamic>?>(
                            context: context,
                            builder: (context) {
                              return ChangeNotifierProvider.value(
                                value: PxVisits(
                                  api: VisitsApi(added_by: ''),
                                ),
                                child: VisitSelectFeesAmountDialog(
                                  call: call,
                                ),
                              );
                            },
                          );
                      if (name_and_fees != null) {
                        _patient_name = name_and_fees['name'];
                        _fees_amount = name_and_fees['fees'];
                      } else {
                        return;
                      }
                    }
                    if (widget.auth.organization != null &&
                        x.fcm_token != null &&
                        context.mounted) {
                      await shellFunction(
                        context,
                        toExecute: () {
                          ClientNotificationFormatterSender(
                              api: const FcmNotificationsApi(),
                              organizationExpanded: widget.auth.organization!,
                              isEnglish: widget.isEnglish,
                            )
                            ..formatFromClinicCall(
                              call: call,
                              client_token: x.fcm_token!,
                              doctor_name: widget.isEnglish
                                  ? '${widget.d.doctor?.name_en}'
                                  : '${widget.d.doctor?.name_ar}',
                              fees_amount: _fees_amount,
                              patient_name: _patient_name,
                            )
                            ..send();
                        },
                      );
                    }
                  },
                );
              }),
            ];
          },
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.top,
            leading: const Icon(
              Icons.notification_important_outlined,
              color: Colors.black,
            ),
            title: Text(x.name),
          ),
        ),
      );
    }),
  ];

  late final List<PopupMenuEntry> _doctorBtns = [
    ...widget.doctors.map((x) {
      return PopupMenuItem<User>(
        child: PopupMenuButton(
          offset: widget.isEnglish ? Offset(-150, 25) : Offset(150, 25),

          elevation: 6,
          borderRadius: BorderRadius.circular(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
            side: BorderSide(),
          ),
          itemBuilder: (context) {
            return [
              ...AssistantClinicCall.calls.map((
                call,
              ) {
                return PopupMenuItem(
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.top,
                    leading: Icon(
                      call.iconData,
                      color: Colors.black,
                    ),
                    title: Text(
                      widget.isEnglish ? call.en : call.ar,
                    ),
                  ),
                  onTap: () async {
                    if (widget.auth.organization != null &&
                        x.fcm_token != null) {
                      await shellFunction(
                        context,
                        toExecute: () {
                          ClientNotificationFormatterSender(
                              api: const FcmNotificationsApi(),
                              organizationExpanded: widget.auth.organization!,
                              isEnglish: widget.isEnglish,
                            )
                            ..formatFromClinicCall(
                              call: call,
                              client_token: x.fcm_token!,
                            )
                            ..send();
                        },
                      );
                    }
                  },
                );
              }),
            ];
          },
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.top,
            leading: const Icon(
              Icons.notification_important_outlined,
              color: Colors.black,
            ),
            title: Text(x.name),
          ),
        ),
      );
    }),
  ];
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void>(
      offset: widget.isEnglish ? Offset(-100, 50) : Offset(100, 50),
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(),
      ),
      itemBuilder: (context) {
        return !widget.auth.isUserNotDoctor ? _assistantBtns : _doctorBtns;
      },
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        leading: const Icon(Icons.settings_voice),
        title: Text(context.loc.clinicCalls),
      ),
    );
  }
}
