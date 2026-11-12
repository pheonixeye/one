import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/pi_lab.dart';
import 'package:one/models/preset.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_presets.dart';
import 'package:one/providers/px_profile_items/px_pi_labs.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class LabPresetCreateEditDialog extends StatefulWidget {
  const LabPresetCreateEditDialog({
    super.key,
    required this.selectedLabs,
    required this.type,
  });
  final List<String> selectedLabs;
  final PresetType type;

  @override
  State<LabPresetCreateEditDialog> createState() =>
      _LabPresetCreateEditDialogState();
}

class _LabPresetCreateEditDialogState extends State<LabPresetCreateEditDialog> {
  late final formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  final ValueNotifier<List<String>> _labsNotifier = ValueNotifier([]);

  void _addPiLab(String id) {
    _labsNotifier.value = [..._labsNotifier.value, id];
  }

  void _removePiLab(String id) {
    final _current = _labsNotifier.value;
    final _index = _current.indexOf(id);
    _current.removeAt(_index);
    _labsNotifier.value = [..._current];
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _labsNotifier.value = [...widget.selectedLabs];
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxPiLabs, PxPresets, PxLocale>(
      builder: (context, lb, p, l, _) {
        while (lb.labs == null || p.result == null) {
          return const CentralLoading();
        }

        while (lb.labs is ApiErrorResult || p.result is ApiErrorResult) {
          return CentralError(
            code: (p.result as ApiErrorResult).errorCode,
            toExecute: () async {
              lb.retry();
              p.retry();
            },
          );
        }
        final _piLabs = (lb.labs as ApiDataResult<List<PiLab>>).data;

        return AlertDialog(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.heightOf(context),
            minHeight: MediaQuery.heightOf(context) / 3,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.addNewLabsPreset,
                  ),
                ),
              ),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          scrollable: true,
          contentPadding: const EdgeInsets.all(8),
          content: ValueListenableBuilder(
            valueListenable: _labsNotifier,
            builder: (context, _, _) {
              return Form(
                key: formKey,
                child: Column(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.presetTitle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.loc.enterTitleForPreset;
                          }
                          return null;
                        },
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.labs),
                    ),
                    ..._piLabs.map((pl) {
                      final _isSelected = _labsNotifier.value.contains(
                        pl.id,
                      );
                      return Card.outlined(
                        child: CheckboxListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              l.isEnglish ? pl.name_en : pl.name_ar,
                            ),
                          ),
                          value: _isSelected,
                          onChanged: (val) {
                            if (_isSelected) {
                              _removePiLab(pl.id);
                            } else {
                              _addPiLab(pl.id);
                            }
                          },
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final _preset = Preset(
                    id: '',
                    title: _titleController.text,
                    doc_id: context.read<PxAuth>().doc_id,
                    type: PresetType.lab,
                    preset: [..._labsNotifier.value],
                  );

                  Navigator.pop(context, _preset);
                }
              },
              label: Text(context.loc.confirm),
              icon: Icon(Icons.check, color: Colors.green.shade100),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: Text(context.loc.cancel),
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
