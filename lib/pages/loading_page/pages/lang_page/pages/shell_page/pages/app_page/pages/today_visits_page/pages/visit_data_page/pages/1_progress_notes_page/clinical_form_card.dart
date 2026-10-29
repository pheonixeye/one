import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient_form_item.dart';
import 'package:one/providers/px_patient_forms.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class ClinicalFormCard extends StatelessWidget {
  const ClinicalFormCard({super.key, required this.form});
  final PatientFormItem form;
  @override
  Widget build(BuildContext context) {
    final pf = context.read<PxPatientForms>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card.outlined(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.top,

            trailing: SmBtn(
              tooltip: context.loc.deleteForm,
              backgroundColor: Colors.red,
              onPressed: () async {
                final _confirmDeleteForm = await showDialog<bool?>(
                  context: context,
                  builder: (context) {
                    return PromptDialog(
                      message: context.loc.confirmDeleteForm,
                    );
                  },
                );
                if (_confirmDeleteForm == null || _confirmDeleteForm == false) {
                  return;
                }
                if (context.mounted) {
                  await shellFunction(
                    context,
                    toExecute: () async {
                      await pf.detachFormFromPatient(
                        form,
                      );
                    },
                  );
                }
              },
              child: const Icon(
                Icons.delete_forever,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              child: Text.rich(
                TextSpan(
                  text: '',
                  children: [
                    ...form.form_data.map((
                      data,
                    ) {
                      return TextSpan(
                        text: '',
                        children: [
                          TextSpan(text: '* '),
                          TextSpan(
                            text: data.field_name,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: ': ${data.field_value}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: '\n\n',
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
