import 'package:one/models/pc_form.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient_form_field_data.dart';
import 'package:one/models/patient_form_item.dart';
import 'package:one/models/pc_form_field_types.dart';
import 'package:one/providers/px_forms.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_forms.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class PatientFormsDialog extends StatefulWidget {
  const PatientFormsDialog({super.key});

  @override
  State<PatientFormsDialog> createState() => _PatientFormsDialogState();
}

class _PatientFormsDialogState extends State<PatientFormsDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.patientForms)),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Consumer3<PxForms, PxPatientForms, PxLocale>(
          builder: (context, f, pf, l, _) {
            return Scaffold(
              appBar: TabBar(
                physics: const NeverScrollableScrollPhysics(),
                onTap: (value) {
                  if (value == 1) {
                    _tabController.animateTo(0);
                    return;
                  } else if (value == 0) {
                    context.read<PxPatientForms>().nullifyForms();
                    return;
                  }
                },
                controller: _tabController,
                tabs: [
                  Tab(text: context.loc.forms),
                  Tab(
                    text: pf.pcForm == null
                        ? context.loc.fillForm
                        : l.isEnglish
                        ? pf.pcForm?.name_en
                        : pf.pcForm?.name_ar,
                  ),
                ],
              ),
              body: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Builder(
                      builder: (context) {
                        while (f.result == null || pf.result == null) {
                          return const CentralLoading();
                        }
                        while (f.result is ApiErrorResult ||
                            pf.result is ApiErrorResult) {
                          return CentralError(
                            code: (f.result as ApiErrorResult).errorCode,
                            toExecute: () async {
                              await Future.wait([f.retry(), pf.retry()]);
                            },
                          );
                        }
                        while (f.result != null &&
                            (f.result as ApiDataResult<List<PcForm>>)
                                .data
                                .isEmpty) {
                          return CentralNoItems(
                            message: context.loc.noFormsFound,
                          );
                        }
                        final _pcForms =
                            (f.result as ApiDataResult<List<PcForm>>).data;
                        return ListView.builder(
                          itemCount: _pcForms.length,
                          itemBuilder: (context, index) {
                            final _pcForm = _pcForms[index];

                            final _formItem =
                                (pf.result
                                        as ApiDataResult<List<PatientFormItem>>)
                                    .data
                                    .firstWhereOrNull(
                                      (e) => e.form_id == _pcForm.id,
                                    );
                            // print('_formItem => $_formItem');
                            final _value = _formItem == null
                                ? false
                                : _formItem.form_id == _pcForm.id;

                            return Card.outlined(
                              elevation: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            l.isEnglish
                                                ? _pcForm.name_en
                                                : _pcForm.name_ar,
                                          ),
                                        ),
                                        //todo: patient_forms contains this form
                                        value: _value,
                                        onChanged: (val) async {
                                          //todo: attach/detach form to patient
                                          await shellFunction(
                                            context,
                                            toExecute: () async {
                                              if (_value) {
                                                final _toDetach =
                                                    await showDialog<bool>(
                                                      context: context,
                                                      builder: (context) {
                                                        return PromptDialog(
                                                          message: context
                                                              .loc
                                                              .confirmDeleteForm,
                                                        );
                                                      },
                                                    );
                                                if (_toDetach == true) {
                                                  await pf
                                                      .detachFormFromPatient(
                                                        _formItem,
                                                      );
                                                }
                                              } else {
                                                await pf.attachFormToPatient(
                                                  PatientFormItem(
                                                    id: '',
                                                    patient_id:
                                                        pf.api.patient_id,
                                                    form_id: _pcForm.id,
                                                    form_data: [
                                                      ..._pcForm.form_fields.map((
                                                        _f,
                                                      ) {
                                                        return PatientFormFieldData(
                                                          id: _f.id,
                                                          field_name:
                                                              _f.field_name,
                                                          field_value: '',
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SmBtn(
                                        tooltip: context.loc.fillForm,
                                        onPressed: () async {
                                          //todo: navigate to edit page with form designed
                                          if (_formItem == null) {
                                            showIsnackbar(
                                              context.loc.addFormBeforeEditing,
                                            );
                                            return;
                                          }
                                          await shellFunction(
                                            context,
                                            toExecute: () async {
                                              await pf.selectForms(
                                                _pcForm,
                                                _formItem,
                                              );
                                              _tabController.animateTo(1);
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
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Builder(
                      builder: (context) {
                        while (pf.pcForm == null || pf.formItem == null) {
                          return CentralNoItems(
                            message: context.loc.noFormIsSelected,
                          );
                        }
                        return ListView.builder(
                          itemCount: pf.pcForm?.form_fields.length,
                          itemBuilder: (context, index) {
                            final _formField = pf.pcForm?.form_fields[index];

                            while (_formField == null) {
                              return Card.outlined(
                                elevation: 6,
                                child: SizedBox(
                                  height: 40,
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.amber.shade50,
                                  ),
                                ),
                              );
                            }
                            final _patientFormData = pf.formItem!.form_data
                                .firstWhereOrNull(
                                  (__f) => __f.id == _formField.id,
                                );
                            return Card.outlined(
                              elevation: 6,
                              color: switch (_formField.field_type) {
                                PcFormFieldType.textfield =>
                                  Colors.green.shade50,
                                PcFormFieldType.dropdown => Colors.blue.shade50,
                                PcFormFieldType.checkbox => Colors.red.shade50,
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: switch (_formField.field_type) {
                                  PcFormFieldType.textfield => ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(_formField.field_name),
                                    ),
                                    subtitle: Builder(
                                      builder: (context) {
                                        final _controller =
                                            TextEditingController(
                                              //todo: change initial value
                                              text:
                                                  _patientFormData?.field_value,
                                            );
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                controller: _controller,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: SmBtn(
                                                onPressed: () async {
                                                  final _toUpdate =
                                                      _patientFormData
                                                          ?.copyWith(
                                                            field_value:
                                                                _controller
                                                                    .text,
                                                          );
                                                  if (_toUpdate != null) {
                                                    await shellFunction(
                                                      context,
                                                      toExecute: () async {
                                                        await pf
                                                            .updatePatientFormFieldData(
                                                              pf.formItem!,
                                                              _toUpdate,
                                                            );
                                                      },
                                                    );
                                                  }
                                                },
                                                child: const Icon(Icons.save),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  PcFormFieldType.dropdown => ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(_formField.field_name),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButtonFormField<String>(
                                              items: _formField.values.map((e) {
                                                return DropdownMenuItem<String>(
                                                  value: e,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    e,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                );
                                              }).toList(),
                                              initialValue:
                                                  _patientFormData
                                                          ?.field_value ==
                                                      ''
                                                  ? null
                                                  : _patientFormData
                                                        ?.field_value,
                                              alignment: Alignment.center,
                                              onChanged: (value) async {
                                                //todo: update values in _formItem.formData

                                                if (value != null) {
                                                  final _toUpdate =
                                                      _patientFormData
                                                          ?.copyWith(
                                                            field_value: value,
                                                          );
                                                  if (_toUpdate != null) {
                                                    await shellFunction(
                                                      context,
                                                      toExecute: () async {
                                                        await pf
                                                            .updatePatientFormFieldData(
                                                              pf.formItem!,
                                                              _toUpdate,
                                                            );
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PcFormFieldType.checkbox => ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(_formField.field_name),
                                    ),
                                    subtitle: Wrap(
                                      children: [
                                        ..._formField.values.map((e) {
                                          return CheckboxListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text(e),
                                            value: _patientFormData?.field_value
                                                .contains(e),
                                            onChanged: (val) async {
                                              //todo:
                                              final _updatedStringAdd =
                                                  _patientFormData!
                                                      .field_value
                                                      .isEmpty
                                                  ? e
                                                  : '${_patientFormData.field_value} - $e';
                                              final _updatedStringList =
                                                  _patientFormData.field_value
                                                      .split('-')
                                                    ..forEach((e) => e.trim());
                                              _updatedStringList.removeWhere(
                                                (va) => va.trim() == e,
                                              );
                                              final _removeBuffer =
                                                  StringBuffer();

                                              _updatedStringList.map((e) {
                                                if (e ==
                                                    _updatedStringList.last) {
                                                  _removeBuffer.write(e);
                                                } else {
                                                  _removeBuffer.write('$e - ');
                                                }
                                              }).toList();
                                              final _toUpdate = _patientFormData
                                                  .copyWith(
                                                    field_value:
                                                        _patientFormData
                                                                .field_value
                                                                .contains(e) ==
                                                            true
                                                        ? _removeBuffer
                                                              .toString()
                                                        : _updatedStringAdd,
                                                  );
                                              // print(_toUpdate);
                                              await shellFunction(
                                                context,
                                                toExecute: () async {
                                                  await pf
                                                      .updatePatientFormFieldData(
                                                        pf.formItem!,
                                                        _toUpdate,
                                                      );
                                                },
                                              );
                                            },
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
