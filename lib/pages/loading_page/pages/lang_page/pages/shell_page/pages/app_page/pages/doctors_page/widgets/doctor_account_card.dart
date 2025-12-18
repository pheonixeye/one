import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/doctor.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class DoctorAccountCard extends StatelessWidget {
  const DoctorAccountCard({
    super.key,
    required this.doctor,
    required this.index,
  });
  final Doctor doctor;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxDoctor, PxLocale>(
      builder: (context, a, d, l, _) {
        final _docUser = d.allDoctorsAuth?.firstWhere((e) => e.id == doctor.id);
        while (_docUser == null) {
          return const SizedBox(height: 8, child: LinearProgressIndicator());
        }
        return Card.outlined(
          elevation: 6,
          color: _docUser.is_active ? null : Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.top,
              leading: SmBtn(
                onPressed: null,
                child: Text('${index + 1}'.toArabicNumber(context)),
              ),
              title: Row(
                children: [
                  Text(l.isEnglish ? doctor.name_en : doctor.name_ar),
                  Text(' - '),
                  Text(
                    '(${l.isEnglish ? doctor.speciality.name_en : doctor.speciality.name_ar})',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  if (!_docUser.is_active) ...[
                    Text(' - '),
                    Text('(${context.loc.inactive})'),
                  ],
                ],
              ),
              subtitle: Row(
                children: [
                  Text(context.loc.phone),
                  Text(' - '),
                  Text.rich(
                    TextSpan(
                      text: doctor.phone.toArabicNumber(context),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          web.window.open('tel://+2${doctor.phone}', '_blank');
                        },
                    ),
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              trailing: ThemedPopupmenuBtn<void>(
                tooltip: context.loc.settings,
                icon: const Icon(Icons.menu),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(Icons.person_add_alt),
                          Text(context.loc.toogleAccountActivity),
                        ],
                      ),
                      onTap: () async {
                        final _isSuperAdmin = PxAuth.isLoggedInUserSuperAdmin(
                          context,
                        );

                        if (!_isSuperAdmin) {
                          showIsnackbar(context.loc.needSuperAdminPermission);
                          return;
                        }

                        if (doctor.id == PxAuth.doc_id_static_getter &&
                            _isSuperAdmin) {
                          showIsnackbar(
                            context.loc.cannotDeactivateSuperAdminAccount,
                          );
                          return;
                        }

                        final _toDeactivate = _docUser.is_active == true;

                        if (_toDeactivate == true) {
                          final _toToggle = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return PromptDialog(
                                message:
                                    context.loc.toogleAccountActivityPrompt,
                              );
                            },
                          );

                          if (_toToggle == null || _toToggle == false) {
                            return;
                          }
                        }
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await d.toogleAccountActivation(
                                doctor.id,
                                !_docUser.is_active,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ];
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
