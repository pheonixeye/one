import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/pc_form.dart';
import 'package:one/models/pc_form_field.dart';
import 'package:one/models/pc_form_field_types.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/forms_page/widgets/create_edit_form_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/forms_page/widgets/edit_field_name_dialog.dart';
import 'package:one/providers/px_forms.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FormViewEditCard extends StatefulWidget {
  const FormViewEditCard({
    super.key,
    required this.pcForm,
    required this.index,
  });
  final PcForm pcForm;
  final int index;
  @override
  State<FormViewEditCard> createState() => _FormViewEditCardState();
}

class _FormViewEditCardState extends State<FormViewEditCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxForms, PxLocale>(
      builder: (context, f, l, _) {
        return Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              shape: Border.all(),
              backgroundColor: Colors.orange.shade50,
              leading: SmBtn(
                onPressed: null,
                child: Text('${widget.index + 1}'),
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  l.isEnglish ? widget.pcForm.name_en : widget.pcForm.name_ar,
                ),
              ),
              // ignore: sort_child_properties_last
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.formFields),
                    ),
                    subtitle: const Divider(),
                  ),
                ),
                ...widget.pcForm.form_fields.map((field) {
                  return Card.outlined(
                    elevation: 6,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                      side: BorderSide(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Text(context.loc.fieldName),
                              const SizedBox(width: 10),
                              Expanded(child: Text(field.field_name)),
                              SmBtn(
                                tooltip: context.loc.editFormFieldName,
                                onPressed: () async {
                                  //@permission
                                  final _perm = context
                                      .read<PxAuth>()
                                      .isActionPermitted(
                                        PermissionEnum.User_Forms_Modify,
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
                                  final _newFieldName =
                                      await showDialog<String?>(
                                        context: context,
                                        builder: (context) {
                                          return EditFieldNameDialog(
                                            fieldName: field.field_name,
                                          );
                                        },
                                      );
                                  if (_newFieldName == null) {
                                    return;
                                  }
                                  final _newFieldToUpdateName = field.copyWith(
                                    field_name: _newFieldName,
                                  );
                                  if (context.mounted) {
                                    await shellFunction(
                                      context,
                                      toExecute: () async {
                                        await f.updateFieldValue(
                                          widget.pcForm,
                                          _newFieldToUpdateName,
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Icon(Icons.edit),
                              ),
                              const SizedBox(width: 10),
                              SmBtn(
                                tooltip: context.loc.deleteFormField,
                                backgroundColor: Colors.red.shade300,
                                onPressed: () async {
                                  //@permission
                                  final _perm = context
                                      .read<PxAuth>()
                                      .isActionPermitted(
                                        PermissionEnum.User_Forms_Modify,
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
                                  final _toRemove = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return PromptDialog(
                                        message:
                                            context.loc.confirmDeleteFormField,
                                      );
                                    },
                                  );
                                  if (_toRemove == null || _toRemove == false) {
                                    return;
                                  }

                                  if (context.mounted) {
                                    await shellFunction(
                                      context,
                                      toExecute: () async {
                                        await f.removeFieldFromForm(
                                          widget.pcForm,
                                          field,
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Icon(Icons.delete),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        subtitle: Column(
                          spacing: 10,
                          children: [
                            Row(
                              children: [
                                Text(context.loc.fieldType),
                                const SizedBox(width: 10),
                                ...PcFormFieldType.values.map((type) {
                                  return Expanded(
                                    child: FilterChip.elevated(
                                      selected: type == field.field_type,
                                      label: Text(type.name),
                                      onSelected: (value) async {
                                        //@permission
                                        final _perm = context
                                            .read<PxAuth>()
                                            .isActionPermitted(
                                              PermissionEnum.User_Forms_Modify,
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
                                        //todo: update field type
                                        final _newFieldWithUpdatedType = field
                                            .copyWith(field_type: type);
                                        await shellFunction(
                                          context,
                                          toExecute: () async {
                                            await f.updateFieldValue(
                                              widget.pcForm,
                                              _newFieldWithUpdatedType,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                            Builder(
                              builder: (context) {
                                final _buffer = StringBuffer();
                                field.values.map((e) {
                                  if (e == field.values.last) {
                                    _buffer.write(e);
                                  } else {
                                    _buffer.write('$e - ');
                                  }
                                }).toList();
                                final _valuesController = TextEditingController(
                                  text: _buffer.toString(),
                                );
                                final _formKey = GlobalKey<FormState>();
                                return Form(
                                  key: _formKey,
                                  child: Row(
                                    children: [
                                      Text(context.loc.fieldValues),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _valuesController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            hintText: context
                                                .loc
                                                .commaSeparatedValues,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SmBtn(
                                          tooltip: context.loc.save,
                                          onPressed: () async {
                                            //@permission
                                            final _perm = context
                                                .read<PxAuth>()
                                                .isActionPermitted(
                                                  PermissionEnum
                                                      .User_Forms_Modify,
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
                                            //todo: save default values / selections
                                            final _fieldToUpdate = field
                                                .copyWith(
                                                  values: _valuesController.text
                                                      .split('-')
                                                      .map((e) => e.trim())
                                                      .toList(),
                                                );
                                            await shellFunction(
                                              context,
                                              toExecute: () async {
                                                await f.updateFieldValue(
                                                  widget.pcForm,
                                                  _fieldToUpdate,
                                                );
                                              },
                                            );
                                          },
                                          child: const Icon(Icons.save),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
              //form_actions
              trailing: ThemedPopupmenuBtn<void>(
                tooltip: context.loc.settings,
                icon: const Icon(Icons.settings),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<void>(
                      child: Row(
                        children: [
                          const Icon(Icons.add_business),
                          Text(context.loc.addNewField),
                        ],
                      ),
                      onTap: () async {
                        //@permission
                        final _perm = context.read<PxAuth>().isActionPermitted(
                          PermissionEnum.User_Forms_Modify,
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
                        final _newField = PcFormField(
                          id: const Uuid().v4(),
                          field_name: 'new_field',
                          field_type: PcFormFieldType.textfield,
                          values: const [],
                        );
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await f.addNewFieldToForm(widget.pcForm, _newField);
                          },
                        );
                      },
                    ),
                    PopupMenuItem<void>(
                      child: Row(
                        children: [
                          const Icon(Icons.edit_document),
                          Text(context.loc.editForm),
                        ],
                      ),
                      onTap: () async {
                        //@permission
                        final _perm = context.read<PxAuth>().isActionPermitted(
                          PermissionEnum.User_Forms_Modify,
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
                        final _toUpdate = await showDialog<PcForm?>(
                          context: context,
                          builder: (context) {
                            return CreateEditFormDialog(form: widget.pcForm);
                          },
                        );
                        if (_toUpdate == null) {
                          return;
                        }
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await f.updatePcForm(_toUpdate);
                            },
                          );
                        }
                      },
                    ),
                    PopupMenuItem<void>(
                      child: Row(
                        children: [
                          const Icon(Icons.delete_forever),
                          Text(context.loc.deleteForm),
                        ],
                      ),
                      onTap: () async {
                        //@permission
                        final _perm = context.read<PxAuth>().isActionPermitted(
                          PermissionEnum.User_Forms_Delete,
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
                        final _toDelete = await showDialog<bool?>(
                          context: context,
                          builder: (context) {
                            return PromptDialog(
                              message: context.loc.confirmDeleteForm,
                            );
                          },
                        );
                        if (_toDelete == null || _toDelete == false) {
                          return;
                        }
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await f.deletePcForm(widget.pcForm.id);
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
