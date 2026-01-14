import 'package:one/extensions/number_translator.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/patient_info_card_actions.dart';
import 'package:one/providers/px_auth.dart';
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: Text(patient.name)),
                  SmBtn(
                    tooltip: context.loc.editPatientData,
                    onPressed: () async {
                      //todo: edit patient name/phone/dob
                      //@permission
                      final _perm = context.read<PxAuth>().isActionPermitted(
                        PermissionEnum.User_Patient_EditInfo,
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
                    child: const Icon(Icons.edit),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              titleAlignment: ListTileTitleAlignment.top,
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: context.loc.dateOfBirth,
                              children: [
                                TextSpan(text: ' : '),
                                TextSpan(
                                  text: DateFormat(
                                    'dd / MM / yyyy',
                                    context.read<PxLocale>().lang,
                                  ).format(DateTime.parse(patient.dob)),
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: context.loc.phone,
                              children: [
                                TextSpan(text: ' : '),
                                TextSpan(text: patient.phone),
                                TextSpan(text: '  '),
                                WidgetSpan(
                                  child: InkWell(
                                    child: const Icon(Icons.call),
                                    onTap: () async {
                                      //@permission
                                      final _perm = context
                                          .read<PxAuth>()
                                          .isActionPermitted(
                                            PermissionEnum.User_Patient_Call,
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
                                    ),
                                    onTap: () async {
                                      //@permission
                                      final _perm = context
                                          .read<PxAuth>()
                                          .isActionPermitted(
                                            PermissionEnum
                                                .User_Patient_Whatsapp,
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
                                children: [
                                  TextSpan(text: ' : '),
                                  TextSpan(
                                    text: patient.email,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        //@permission
                                        final _perm = context
                                            .read<PxAuth>()
                                            .isActionPermitted(
                                              PermissionEnum.User_Patient_Email,
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
                                        web.window.open(
                                          'mailto://${patient.email}',
                                          '_blank',
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    PatientInfoCardActions(patient: patient),
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
