import 'package:go_router/go_router.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/fcm_notifications_api.dart';
import 'package:one/core/logic/client_notification_formatter_sender.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/notifications/in_app_action.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/add_new_visit_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/patient_info_card_actions.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/create_edit_patient_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patients.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class PatientInfoCard extends StatelessWidget {
  const PatientInfoCard({
    super.key,
    required this.patient,
    required this.index,
  });
  final Patient patient;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer3<PxAppConstants, PxPatients, PxClinics>(
          builder: (context, a, p, c, _) {
            while (c.result == null || a.constants == null) {
              return const ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              );
            }
            return ListTile(
              leading: SmBtn(
                onPressed: null,
                child: Text('${index + 1}'.toArabicNumber(context)),
              ),

              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: patient.name,
                        children: [
                          TextSpan(text: '  '),
                          WidgetSpan(
                            child: Tooltip(
                              message: context.loc.editPatientData,
                              child: InkWell(
                                onTap: () async {
                                  //todo: edit patient name/phone/dob
                                  //@permission
                                  final _perm = context
                                      .read<PxAuth>()
                                      .isActionPermitted(
                                        PermissionEnum.User_Patient_EditInfo,
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
                                  final _patient = await showDialog<Patient?>(
                                    context: context,
                                    builder: (context) {
                                      return CreateEditPatientDialog(
                                        patient: patient,
                                      );
                                    },
                                  );
                                  if (_patient == null) {
                                    return;
                                  }
                                  if (context.mounted) {
                                    await shellFunction(
                                      context,
                                      toExecute: () async {
                                        await p.editPatientBaseData(_patient);
                                      },
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(text: '  '),
                          WidgetSpan(
                            child: Tooltip(
                              message: context.loc.addNewVisit,
                              child: InkWell(
                                mouseCursor: SystemMouseCursors.zoomIn,
                                onTap: () async {
                                  //@permission
                                  final _perm = context
                                      .read<PxAuth>()
                                      .isActionPermitted(
                                        PermissionEnum.User_Patient_AddNewVisit,
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
                                  final _visitDto = await showDialog<Visit?>(
                                    context: context,
                                    builder: (context) {
                                      return ChangeNotifierProvider.value(
                                        value: c,
                                        child: ChangeNotifierProvider(
                                          create: (context) =>
                                              PxAddNewVisitDialog(
                                                context: context,
                                              ),
                                          child: AddNewVisitDialog(
                                            patient: patient,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  if (_visitDto == null) {
                                    return;
                                  }
                                  //todo:
                                  if (context.mounted) {
                                    await shellFunction(
                                      context,
                                      toExecute: () async {
                                        await context
                                            .read<PxVisits>()
                                            .addNewVisit(
                                              _visitDto,
                                            );
                                        if (context.mounted) {
                                          final _clinic =
                                              (c.result
                                                      as ApiDataResult<
                                                        List<Clinic>
                                                      >)
                                                  .data
                                                  .firstWhere(
                                                    (c) =>
                                                        c.id ==
                                                        _visitDto.clinic_id,
                                                  );
                                          ClientNotificationFormatterSender(
                                              api: const FcmNotificationsApi(),
                                              organizationExpanded: context
                                                  .read<PxAuth>()
                                                  .organization!,
                                              isEnglish: context
                                                  .read<PxLocale>()
                                                  .isEnglish,
                                            )
                                            ..formatFromInAppAction(
                                              action: InAppAction.add_new_visit,
                                              account_types: context
                                                  .read<PxAppConstants>()
                                                  .constants!
                                                  .accountTypes,
                                              patient_name: patient.name,
                                              clinic_name:
                                                  context
                                                      .read<PxLocale>()
                                                      .isEnglish
                                                  ? _clinic.name_en
                                                  : _clinic.name_ar,
                                              visit_date: _visitDto.visit_date,
                                              visit_type: _visitDto.visit_type,
                                            )
                                            ..send();
                                        }
                                        //todo: notify patient with visit details && entry number => manual
                                        //todo: generate bookkeeping entry based on the state of the visit
                                      },
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                    );
                                  }
                                  if (context.mounted) {
                                    GoRouter.of(context).goNamed(
                                      AppRouter.app,
                                      pathParameters: defaultPathParameters(
                                        context,
                                      ),
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    PatientInfoCardActions(patient: patient),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              titleAlignment: ListTileTitleAlignment.top,
              subtitle: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: context.loc.dateOfBirth,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(text: ' : '),
                          if (patient.dob.isNotEmpty)
                            TextSpan(
                              text: DateFormat(
                                'dd / MM / yyyy',
                                context.read<PxLocale>().lang,
                              ).format(DateTime.parse(patient.dob)),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            )
                          else
                            TextSpan(
                              text: '-- / -- / ----',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: context.loc.phone,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: patient.phone,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(text: '  '),
                          WidgetSpan(
                            child: InkWell(
                              child: const Icon(
                                Icons.call,
                                size: 16,
                              ),
                              onTap: () async {
                                //@permission
                                final _perm = context
                                    .read<PxAuth>()
                                    .isActionPermitted(
                                      PermissionEnum.User_Patient_Call,
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
                                web.window.open(
                                  'tel://+2${patient.phone}',
                                  '_blank',
                                );
                              },
                            ),
                          ),
                          TextSpan(text: '  '),
                          WidgetSpan(
                            child: InkWell(
                              child: const Icon(
                                FontAwesomeIcons.whatsapp,
                                size: 16,
                              ),
                              onTap: () async {
                                //@permission
                                final _perm = context
                                    .read<PxAuth>()
                                    .isActionPermitted(
                                      PermissionEnum.User_Patient_Whatsapp,
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
                                web.window.open(
                                  'https://wa.me/+2${patient.phone}',
                                  '_blank',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (patient.email.isNotEmpty)
                      Text.rich(
                        TextSpan(
                          text: context.loc.email,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: ' : '),
                            if (patient.email.isNotEmpty)
                              TextSpan(
                                text: patient.email,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    //@permission
                                    final _perm = context
                                        .read<PxAuth>()
                                        .isActionPermitted(
                                          PermissionEnum.User_Patient_Email,
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
                                    web.window.open(
                                      'mailto://${patient.email}',
                                      '_blank',
                                    );
                                  },
                              )
                            else
                              TextSpan(text: ''),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
