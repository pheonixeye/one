import 'package:one/extensions/number_translator.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/pc_form.dart';
import 'package:one/models/pc_form_field_types.dart';
import 'package:one/models/visit_data/visit_form_item.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class VisitFormViewEditCard extends StatefulWidget {
  const VisitFormViewEditCard({
    super.key,
    required this.form,
    required this.form_data,
    required this.index,
  });
  final PcForm form;
  final int index;
  final VisitFormItem form_data;

  @override
  State<VisitFormViewEditCard> createState() => _VisitFormViewEditCardState();
}

class _VisitFormViewEditCardState extends State<VisitFormViewEditCard> {
  VisitFormItem? _state;

  @override
  void initState() {
    super.initState();
    _state = widget.form_data;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitData, PxLocale>(
      builder: (context, v, l, _) {
        return Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              showTrailingIcon: false,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SmBtn(
                      child: Text(
                        '${widget.index + 1}'.toArabicNumber(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l.isEnglish ? widget.form.name_en : widget.form.name_ar,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SmBtn(
                      tooltip: context.loc.deleteForm,
                      backgroundColor: Colors.red.shade200,
                      onPressed: () async {
                        //todo: detach Form
                        final _toDetach = await showDialog<bool?>(
                          context: context,
                          builder: (context) {
                            return PromptDialog(
                              message: context.loc.detachFormPrompt,
                            );
                          },
                        );
                        if (_toDetach == null || _toDetach == false) {
                          return;
                        }
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await v.detachForm(widget.form_data);
                            },
                          );
                        }
                      },
                      child: const Icon(Icons.delete_forever),
                    ),
                  ),
                ],
              ),
              children: [
                ...widget.form.form_fields.map((e) {
                  var _form_field = _state?.form_data.firstWhere(
                    (x) => x.id == e.id,
                  );

                  var _form_field_index = _state?.form_data.indexOf(
                    _form_field!,
                  );

                  return switch (e.field_type) {
                    PcFormFieldType.textfield => ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e.field_name),
                      ),
                      subtitle: Builder(
                        builder: (context) {
                          return IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    initialValue: widget.form_data.form_data
                                        .firstWhere((f) => f.id == e.id)
                                        .field_value,
                                    // controller: _controller,
                                    expands: true,
                                    maxLines: null,
                                    minLines: null,
                                    onChanged: (value) {
                                      var _updated = _form_field?.copyWith(
                                        field_value: value,
                                      );

                                      var _new_fields = _state?.form_data;

                                      _new_fields![_form_field_index!] =
                                          _updated!;

                                      setState(() {
                                        _state = _state?.copyWith(
                                          form_data: _new_fields,
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    PcFormFieldType.dropdown => ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e.field_name),
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                items: e.values.map((e) {
                                  return DropdownMenuItem<String>(
                                    value: e,
                                    alignment: Alignment.center,
                                    child: Text(e, textAlign: TextAlign.center),
                                  );
                                }).toList(),
                                value:
                                    _state?.form_data
                                            .firstWhereOrNull(
                                              (x) => x.id == e.id,
                                            )
                                            ?.field_value ==
                                        ''
                                    ? null
                                    : _state?.form_data
                                          .firstWhereOrNull((x) => x.id == e.id)
                                          ?.field_value, //todo
                                alignment: Alignment.center,
                                onChanged: (value) {
                                  //todo:

                                  var _updated = _form_field?.copyWith(
                                    field_value: value,
                                  );

                                  var _new_fields = _state?.form_data;

                                  _new_fields![_form_field_index!] = _updated!;

                                  setState(() {
                                    _state = _state?.copyWith(
                                      form_data: _new_fields,
                                    );
                                  });
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
                        child: Text(e.field_name),
                      ),
                      subtitle: Wrap(
                        children: [
                          ...e.values.map((f) {
                            final _visitFormData = _state?.form_data
                                .firstWhereOrNull((x) => x.id == e.id);
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(f),
                              tristate: false,
                              value: _state?.form_data
                                  .firstWhereOrNull((x) => x.id == e.id)
                                  ?.field_value
                                  .trim()
                                  .toLowerCase()
                                  .contains(f.toLowerCase()),
                              onChanged: (val) {
                                //todo:
                                final _updatedStringAdd =
                                    _visitFormData!.field_value.isEmpty
                                    ? f
                                    : '${_visitFormData.field_value} - $f';
                                final _updatedStringList =
                                    _visitFormData.field_value.split('-')
                                      ..forEach((e) => e.trim());
                                _updatedStringList.removeWhere(
                                  (va) => va.trim() == f,
                                );
                                final _removeBuffer = StringBuffer();

                                _updatedStringList.map((e) {
                                  if (e == _updatedStringList.last) {
                                    _removeBuffer.write(e);
                                  } else {
                                    _removeBuffer.write('$e - ');
                                  }
                                }).toList();
                                final _toUpdate = _visitFormData.copyWith(
                                  field_value:
                                      _visitFormData.field_value.contains(f) ==
                                          true
                                      ? _removeBuffer.toString()
                                      : _updatedStringAdd,
                                );
                                var _form_field_index = _state?.form_data
                                    .indexOf(_visitFormData);

                                var _new_fields = _state?.form_data;

                                _new_fields![_form_field_index!] = _toUpdate;

                                setState(() {
                                  _state = _state?.copyWith(
                                    form_data: _new_fields,
                                  );
                                });
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  };
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (_state == null) {
                            return;
                          }
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await v.updateFormData(_state!);
                            },
                          );
                        },
                        label: Text(context.loc.save),
                        icon: const Icon(Icons.save),
                      ),
                    ],
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
