import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClinicDoctorsDialog extends StatelessWidget {
  const ClinicDoctorsDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer3<PxClinics, PxDoctor, PxLocale>(
      builder: (context, c, d, l, _) {
        while (d.allDoctors == null || c.result == null) {
          return const CentralLoading();
        }
        return AlertDialog(
          title: Row(
            children: [
              Text.rich(
                TextSpan(
                  text: context.loc.clinicDoctors,
                  children: [
                    TextSpan(text: '\n'),
                    TextSpan(
                      text:
                          '(${l.isEnglish ? c.clinic?.name_en : c.clinic?.name_ar})',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
              SizedBox(width: 10),
            ],
          ),
          scrollable: true,
          contentPadding: const EdgeInsets.all(8),
          content: Column(
            spacing: 4,
            children: [
              if (d.allDoctors != null)
                ...d.allDoctors!.map((doc) {
                  return CheckboxListTile(
                    title: Text(l.isEnglish ? doc.name_en : doc.name_ar),
                    value: c.clinic!.doc_id.contains(doc.id),
                    onChanged: (val) async {
                      final _idToRemove = doc.id;
                      final _operationIsRemove = c.clinic!.doc_id.contains(
                        doc.id,
                      );

                      if (_operationIsRemove) {
                        if (context.read<PxAuth>().doc_id == _idToRemove) {
                          showIsnackbar(
                            context.loc.cannotRemoveSelfFromClinicWhileLoggedIn,
                          );
                          return;
                        }
                        final _toRemoveDoctor = await showDialog<bool?>(
                          context: context,
                          builder: (context) {
                            return PromptDialog(
                              message: context.loc.removeDoctorFromClinicPrompt,
                            );
                          },
                        );
                        if (_toRemoveDoctor == null ||
                            _toRemoveDoctor == false) {
                          return;
                        }
                      }

                      if (context.mounted) {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await c.addOrRemoveDoctorFromClinic(doc.id);
                            c.selectClinic(c.clinic);
                          },
                        );
                      }
                    },
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
