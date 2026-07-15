import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient_form_field_data.dart';
import 'package:one/models/patient_form_item.dart';
import 'package:one/models/pk_form.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_forms.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:provider/provider.dart';

class FormViewAssignCard extends StatelessWidget {
  const FormViewAssignCard({
    super.key,
    required this.form,
    required this.patientFormItem,
    required this.tabController,
    required this.value,
    required this.index,
  });
  final PkForm form;
  final PatientFormItem? patientFormItem;
  final TabController tabController;
  final bool value;
  final int index;

  @override
  Widget build(BuildContext context) {
    //TODO: this widget logic and ui needs to be refectored - not functioning properly
    return Consumer4<PxAuth, PxPatientForms, PxDoctor, PxLocale>(
      builder: (context, auth, pf, d, l, _) {
        while (d.allDoctors == null) {
          return const SizedBox(
            height: 8,
            child: LinearProgressIndicator(),
          );
        }
        if (context.read<PxAuth>().isUserNotDoctor) {
          return Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                leading: SmBtn(
                  child: Text('${index + 1}'.toArabicNumber(context)),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    l.isEnglish ? form.name_en : form.name_ar,
                  ),
                ),
                childrenPadding: const EdgeInsetsDirectional.only(start: 50),
                initiallyExpanded: true,
                children: [
                  if (d.allDoctors != null)
                    ...d.allDoctors!.map((doc) {
                      final _valueForDoctor =
                          // value &&
                          patientFormItem != null &&
                          patientFormItem!.doc_id == doc.id;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            l.isEnglish ? doc.name_en : doc.name_ar,
                          ),
                          value: _valueForDoctor,
                          onChanged: (val) async {
                            if (_valueForDoctor) {
                              final _toDetach = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return PromptDialog(
                                    message: context.loc.confirmDeleteForm,
                                  );
                                },
                              );
                              if (_toDetach == false || _toDetach == null) {
                                return;
                              } else {
                                if (context.mounted && _valueForDoctor) {
                                  await shellFunction(
                                    context,
                                    toExecute: () async {
                                      await pf.detachFormFromPatient(
                                        patientFormItem!,
                                      );
                                    },
                                  );
                                }
                              }
                            } else {
                              if (context.mounted) {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await pf.attachFormToPatient(
                                      PatientFormItem(
                                        id: '',
                                        doc_id: doc.id,
                                        patient_id: pf.api.patient_id,
                                        form_id: form.id,
                                        form_data: [
                                          ...form.fields.map((
                                            _f,
                                          ) {
                                            return PatientFormFieldData(
                                              id: _f.id,
                                              field_name: _f.field_name,
                                              field_value: '',
                                            );
                                          }),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          },
                          secondary: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SmBtn(
                              tooltip: context.loc.fillForm,
                              onPressed: () async {
                                //todo: navigate to edit page with form designed
                                if (!_valueForDoctor) {
                                  showIsnackbar(
                                    context.loc.addFormBeforeEditing,
                                  );
                                  return;
                                }
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await pf.selectForms(
                                      form,
                                      patientFormItem,
                                    );
                                    tabController.animateTo(1);
                                  },
                                );
                              },
                              child: const Icon(Icons.arrow_forward),
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        }
        return Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        l.isEnglish ? form.name_en : form.name_ar,
                      ),
                    ),
                    //todo: patient_forms contains this form
                    value: value,
                    onChanged: (val) async {
                      //todo: attach/detach form to patient
                      if (value) {
                        final _toDetach = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return PromptDialog(
                              message: context.loc.confirmDeleteForm,
                            );
                          },
                        );
                        if (_toDetach == false || _toDetach == null) {
                          return;
                        } else {
                          if (context.mounted && patientFormItem != null) {
                            await shellFunction(
                              context,
                              toExecute: () async {
                                await pf.detachFormFromPatient(
                                  patientFormItem!,
                                );
                              },
                            );
                          }
                        }
                      } else {
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await pf.attachFormToPatient(
                                PatientFormItem(
                                  id: '',
                                  doc_id: pf.api.doc_id,
                                  patient_id: pf.api.patient_id,
                                  form_id: form.id,
                                  form_data: [
                                    ...form.fields.map((
                                      _f,
                                    ) {
                                      return PatientFormFieldData(
                                        id: _f.id,
                                        field_name: _f.field_name,
                                        field_value: '',
                                      );
                                    }),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmBtn(
                    tooltip: context.loc.fillForm,
                    onPressed: () async {
                      //todo: navigate to edit page with form designed
                      if (patientFormItem == null) {
                        showIsnackbar(
                          context.loc.addFormBeforeEditing,
                        );
                        return;
                      }
                      await shellFunction(
                        context,
                        toExecute: () async {
                          await pf.selectForms(
                            form,
                            patientFormItem,
                          );
                          tabController.animateTo(1);
                        },
                      );
                    },
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
