import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/deep_list_equality.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/doctor_items/pi_rads.dart';
import 'package:one/models/preset.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/pi_rads_page/pi_rad_create_edit_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/5_rads_page/widgets/rad_preset_create_edit_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_presets.dart';
import 'package:one/providers/px_profile_items/px_pi_rads.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class RadsDesktopView extends StatelessWidget {
  const RadsDesktopView({
    super.key,
    required this.infoHeader,
    required this.bottomSheetController,
    required this.p,
    required this.colorAnimation,
    required this.v,
    required this.data,
    required this.toogleIsPresetsVisible,
    required this.searchController,
    required this.rb,
    required this.visitRadsState,
    required this.radsPresets,
    required this.visitRads,
    required this.piRads,
    required this.setPiRadsFromPreset,
    required this.addPiRad,
    required this.removePiRad,
    required this.isPresetsVisible,
  });
  final Widget infoHeader;
  final PxPiRads rb;
  final AnimationController bottomSheetController;
  final ValueListenable<List<String>> visitRadsState;
  final ValueListenable<bool> isPresetsVisible;
  final PxPresets p;
  final List<Preset> radsPresets;
  final List<PiRad> visitRads;
  final List<PiRad> piRads;
  final Animation<Color?> colorAnimation;
  final PxVisitData v;
  final VisitData data;
  final void Function(List<String> radsIds) setPiRadsFromPreset;
  final void Function(String id) addPiRad;
  final void Function(String id) removePiRad;
  final TextEditingController searchController;
  final void Function() toogleIsPresetsVisible;

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return Column(
          spacing: 8,
          children: [
            infoHeader,
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Card.outlined(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText:
                                context.loc.searchByEnglishOrArabicItemName,
                            suffix: InkWell(
                              onTap: () async {
                                if (searchController.text.trim().isEmpty) {
                                  return;
                                }
                                final _piRad = await showDialog<PiRad?>(
                                  context: context,
                                  builder: (context) {
                                    return PiRadCreateEditDialog(
                                      piRad: PiRad(
                                        id: '',
                                        doc_id: context.read<PxAuth>().doc_id,
                                        name_en:
                                            containsArabic(
                                              searchController.text,
                                            )
                                            ? ''
                                            : searchController.text,
                                        name_ar:
                                            containsArabic(
                                              searchController.text,
                                            )
                                            ? searchController.text
                                            : '',
                                        special_instructions: '',
                                        type: RadiologyType.us,
                                      ),
                                    );
                                  },
                                );
                                if (_piRad == null) {
                                  return;
                                }
                                if (context.mounted) {
                                  await shellFunction(
                                    context,
                                    toExecute: () async {
                                      await rb.createItem(_piRad);
                                    },
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.add,
                                size: 16,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            rb.searchForItems(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Tooltip(
                          message: context.loc.clearSearch,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade200,
                            ),
                            onPressed: () {
                              rb.clearSearch();
                            },
                            label: Text(context.loc.clearSearch),
                            icon: const Icon(Icons.clear_all),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Tooltip(
                          message: context.loc.presets,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade200,
                            ),
                            onPressed: () {
                              toogleIsPresetsVisible();
                            },
                            label: Text(context.loc.presets),
                            icon: const Icon(Icons.list_alt_rounded),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Tooltip(
                          message: context.loc.save,
                          child: ValueListenableBuilder(
                            valueListenable: visitRadsState,
                            builder: (context, _, child) {
                              final _isStateSaved = visitRadsState.value
                                  .isDeeplyEqualTo([
                                    ...visitRads.map((l) => l.id),
                                  ]);
                              return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade200,
                                ),
                                onPressed: () async {
                                  await shellFunction(
                                    context,
                                    toExecute: () async {
                                      await v.setRadsOfVisitData(
                                        visit_data_id: data.id,
                                        rads_ids: visitRadsState.value,
                                      );
                                    },
                                  );
                                },
                                label: Text(context.loc.save),
                                icon: _isStateSaved
                                    ? const Icon(Icons.save)
                                    : AnimatedBuilder(
                                        animation: colorAnimation,
                                        builder: (context, child) {
                                          return Icon(
                                            Icons.save,
                                            color: colorAnimation.value,
                                          );
                                        },
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: isPresetsVisible,
                  builder: (context, _, _) {
                    return Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ValueListenableBuilder(
                            valueListenable: visitRadsState,
                            builder: (context, _, _) {
                              return ListView.builder(
                                itemCount: piRads.length,
                                itemBuilder: (context, index) {
                                  final _piRad = piRads[index];
                                  final _isSelected = visitRadsState.value
                                      .contains(
                                        _piRad.id,
                                      );
                                  return Card.outlined(
                                    elevation: _isSelected ? 0 : 6,
                                    color: _isSelected
                                        ? Colors.amber.shade50
                                        : null,
                                    child: CheckboxListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.all(
                                          8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: SmBtn(
                                                child: Text(
                                                  '${index + 1}'.toArabicNumber(
                                                    context,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                l.isEnglish
                                                    ? _piRad.name_en
                                                    : _piRad.name_ar,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      value: _isSelected,
                                      onChanged: (_) {
                                        if (_isSelected) {
                                          removePiRad(_piRad.id);
                                        } else {
                                          addPiRad(_piRad.id);
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        if (isPresetsVisible.value == true) ...[
                          const VerticalDivider(),
                          Expanded(
                            flex: 1,
                            child: Card.outlined(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      8.0,
                                    ),
                                    child: ListTile(
                                      leading: SmBtn(),
                                      trailing: IconButton(
                                        onPressed: () {
                                          setPiRadsFromPreset([]);
                                          setPiRadsFromPreset([
                                            ...visitRads.map(
                                              (e) => e.id,
                                            ),
                                          ]);
                                        },
                                        icon: const Icon(Icons.recycling),
                                      ),
                                      title: Text(
                                        context.loc.presets,
                                        textAlign: TextAlign.start,
                                      ),
                                      subtitle: const Divider(),
                                    ),
                                  ),
                                  Expanded(
                                    child: ValueListenableBuilder(
                                      valueListenable: visitRadsState,
                                      builder: (context, _, _) {
                                        return ListView(
                                          children: [
                                            ...radsPresets.map((
                                              preset,
                                            ) {
                                              final index = radsPresets.indexOf(
                                                preset,
                                              );
                                              final _isPresetSelected =
                                                  visitRadsState.value
                                                      .isDeeplyEqualTo(
                                                        preset.preset
                                                            as List<String>,
                                                      );

                                              return Padding(
                                                padding: const EdgeInsets.all(
                                                  4.0,
                                                ),
                                                child: Card.outlined(
                                                  color: _isPresetSelected
                                                      ? Colors.blue.shade200
                                                      : null,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 4.0,
                                                          horizontal: 8.0,
                                                        ),
                                                    child: ListTile(
                                                      onTap: () {
                                                        if (_isPresetSelected) {
                                                          setPiRadsFromPreset(
                                                            [],
                                                          );
                                                        } else {
                                                          setPiRadsFromPreset(
                                                            preset.preset
                                                                as List<String>,
                                                          );
                                                        }
                                                      },
                                                      leading: SmBtn(
                                                        width: 30,
                                                        height: 30,
                                                        child: Text(
                                                          '${index + 1}',
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                        onPressed: () async {
                                                          final _toDeletePreset =
                                                              await showDialog<
                                                                bool?
                                                              >(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) {
                                                                      return PromptDialog(
                                                                        message: context
                                                                            .loc
                                                                            .deletePresetPrompt,
                                                                      );
                                                                    },
                                                              );
                                                          if (_toDeletePreset ==
                                                                  null ||
                                                              _toDeletePreset ==
                                                                  false) {
                                                            return;
                                                          }
                                                          if (context.mounted) {
                                                            await shellFunction(
                                                              context,
                                                              toExecute: () async {
                                                                await p
                                                                    .deletePreset(
                                                                      preset.id,
                                                                    );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              8.0,
                                                            ),
                                                        child: Text(
                                                          preset.title,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      8.0,
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        final _preset =
                                            await showDialog<Preset?>(
                                              context: context,
                                              builder: (context) {
                                                return RadPresetCreateEditDialog(
                                                  type: PresetType.rad,
                                                  selectedRads: [
                                                    ...visitRadsState.value,
                                                  ],
                                                );
                                              },
                                            );

                                        if (_preset == null) {
                                          return;
                                        }

                                        if (context.mounted) {
                                          await shellFunction(
                                            context,
                                            toExecute: () async {
                                              await p.createNewPreset(
                                                _preset,
                                              );
                                            },
                                          );
                                        }
                                      },
                                      label: Text(
                                        context.loc.newPreset,
                                      ),
                                      icon: const Icon(Icons.save),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
