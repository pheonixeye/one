import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/pi_rads.dart';
import 'package:one/models/preset.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_presets.dart';
import 'package:one/providers/px_profile_items/px_pi_rads.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class RadPresetCreateEditDialog extends StatefulWidget {
  const RadPresetCreateEditDialog({
    super.key,
    required this.selectedRads,
    required this.type,
  });
  final List<String> selectedRads;
  final PresetType type;

  @override
  State<RadPresetCreateEditDialog> createState() =>
      _RadPresetCreateEditDialogState();
}

class _RadPresetCreateEditDialogState extends State<RadPresetCreateEditDialog> {
  late final formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  final ValueNotifier<List<String>> _radsNotifier = ValueNotifier([]);

  void _addPiRad(String id) {
    _radsNotifier.value = [..._radsNotifier.value, id];
  }

  void _removePiRad(String id) {
    final _current = _radsNotifier.value;
    final _index = _current.indexOf(id);
    _current.removeAt(_index);
    _radsNotifier.value = [..._current];
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _radsNotifier.value = [...widget.selectedRads];
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxPiRads, PxPresets, PxLocale>(
      builder: (context, rb, p, l, _) {
        while (rb.rads == null || p.result == null) {
          return const CentralLoading();
        }

        while (rb.rads is ApiErrorResult || p.result is ApiErrorResult) {
          return CentralError(
            code: (p.result as ApiErrorResult).errorCode,
            toExecute: () async {
              rb.retry();
              p.retry();
            },
          );
        }
        final _piRads = (rb.rads as ApiDataResult<List<PiRad>>).data;

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
                    text: context.loc.addNewRadsPreset,
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
            valueListenable: _radsNotifier,
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
                      child: Text(context.loc.rads),
                    ),
                    ..._piRads.map((pr) {
                      final _isSelected = _radsNotifier.value.contains(
                        pr.id,
                      );
                      return Card.outlined(
                        child: CheckboxListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              l.isEnglish ? pr.name_en : pr.name_ar,
                            ),
                          ),
                          value: _isSelected,
                          onChanged: (val) {
                            if (_isSelected) {
                              _removePiRad(pr.id);
                            } else {
                              _addPiRad(pr.id);
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
                    type: PresetType.rad,
                    preset: [..._radsNotifier.value],
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
