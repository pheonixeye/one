import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/deep_list_equality.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/doctor_items/pi_lab.dart';
import 'package:one/models/preset.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/pi_labs_page/pi_lab_create_edit_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/4_labs_page/widgets/preset_create_edit_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_presets.dart';
import 'package:one/providers/px_profile_items/px_pi_labs.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class LabsMobileView extends StatelessWidget {
  const LabsMobileView({
    super.key,
    required this.infoHeader,
    required this.lb,
    required this.bottomSheetController,
    required this.visitLabsState,
    required this.p,
    required this.labsPresets,
    required this.visitLabs,
    required this.piLabs,
    required this.colorAnimation,
    required this.v,
    required this.data,
    required this.setPiLabsFromPreset,
    required this.addPiLab,
    required this.removePiLab,
    required this.searchController,
  });
  final Widget infoHeader;
  final PxPiLabs lb;
  final AnimationController bottomSheetController;
  final ValueListenable<List<String>> visitLabsState;
  final PxPresets p;
  final List<Preset> labsPresets;
  final List<PiLab> visitLabs;
  final List<PiLab> piLabs;
  final Animation<Color?> colorAnimation;
  final PxVisitData v;
  final VisitData data;
  final void Function(List<String> labsIds) setPiLabsFromPreset;
  final void Function(String id) addPiLab;
  final void Function(String id) removePiLab;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return Column(
          children: [
            infoHeader,
            Card.outlined(
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
                          hintText: context.loc.searchByEnglishOrArabicItemName,
                          suffix: InkWell(
                            onTap: () async {
                              if (searchController.text.trim().isEmpty) {
                                return;
                              }
                              final _piLab = await showDialog<PiLab?>(
                                context: context,
                                builder: (context) {
                                  return PiLabCreateEditDialog(
                                    piLab: PiLab(
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
                                    ),
                                  );
                                },
                              );
                              if (_piLab == null) {
                                return;
                              }
                              if (context.mounted) {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await lb.createItem(_piLab);
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
                          lb.searchForItems(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: SmBtn(
                        tooltip: context.loc.clearSearch,
                        backgroundColor: Colors.red.shade200,
                        onPressed: () {
                          lb.clearSearch();
                        },
                        child: const Icon(Icons.refresh),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: SmBtn(
                        tooltip: context.loc.presets,
                        backgroundColor: Colors.teal.shade200,
                        onPressed: () {
                          showModalBottomSheet(
                            transitionAnimationController:
                                bottomSheetController,
                            context: context,
                            showDragHandle: true,
                            enableDrag: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.directional(
                                topEnd: Radius.circular(12),
                                topStart: Radius.circular(12),
                              ),
                            ),
                            builder: (context) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topEnd: Radius.circular(12),
                                    topStart: Radius.circular(12),
                                  ),
                                  color: Colors.blue.shade50,
                                ),
                                constraints: BoxConstraints.tightForFinite(
                                  height: MediaQuery.heightOf(context) / 2,
                                ),
                                child: ValueListenableBuilder(
                                  valueListenable: visitLabsState,
                                  builder: (context, _, _) {
                                    return Column(
                                      children: [
                                        // presets header
                                        Padding(
                                          padding: const EdgeInsets.all(
                                            8.0,
                                          ),
                                          child: ListTile(
                                            leading: SmBtn(),
                                            trailing: IconButton(
                                              onPressed: () {
                                                setPiLabsFromPreset(
                                                  [],
                                                );
                                                setPiLabsFromPreset([
                                                  ...visitLabs.map(
                                                    (e) => e.id,
                                                  ),
                                                ]);
                                              },
                                              icon: const Icon(
                                                Icons.refresh,
                                              ),
                                            ),
                                            title: Text(
                                              context.loc.presets,
                                              textAlign: TextAlign.start,
                                            ),
                                            subtitle: const Divider(),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView(
                                            children: [
                                              //rest of presets
                                              ...labsPresets.map((
                                                preset,
                                              ) {
                                                final index = labsPresets
                                                    .indexOf(
                                                      preset,
                                                    );
                                                final _isPresetSelected =
                                                    visitLabsState.value
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
                                                            setPiLabsFromPreset(
                                                              [],
                                                            );
                                                          } else {
                                                            setPiLabsFromPreset(
                                                              preset.preset
                                                                  as List<
                                                                    String
                                                                  >,
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
                                                            if (context
                                                                .mounted) {
                                                              await shellFunction(
                                                                context,
                                                                toExecute: () async {
                                                                  await p
                                                                      .deletePreset(
                                                                        preset
                                                                            .id,
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
                                          ),
                                        ),
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
                                                      return PresetCreateEditDialog(
                                                        type: PresetType.lab,
                                                        selectedLabs: [
                                                          ...visitLabsState
                                                              .value,
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
                                            icon: const Icon(
                                              Icons.save,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.list_alt_rounded),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: visitLabsState,
                        builder: (context, _, child) {
                          final _isStateSaved = visitLabsState.value
                              .isDeeplyEqualTo([
                                ...visitLabs.map((l) => l.id),
                              ]);
                          return SmBtn(
                            tooltip: context.loc.save,
                            backgroundColor: Colors.green.shade200,
                            onPressed: () async {
                              await shellFunction(
                                context,
                                toExecute: () async {
                                  await v.setLabsOfVisitData(
                                    visit_data_id: data.id,
                                    labs_ids: visitLabsState.value,
                                  );
                                },
                              );
                            },
                            child: _isStateSaved
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
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: visitLabsState,
                builder: (context, _, _) {
                  return ListView.builder(
                    itemCount: piLabs.length,
                    itemBuilder: (context, index) {
                      final _piLab = piLabs[index];
                      final _isSelected = visitLabsState.value.contains(
                        _piLab.id,
                      );
                      return Card.outlined(
                        elevation: 6,
                        child: CheckboxListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
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
                                        ? _piLab.name_en
                                        : _piLab.name_ar,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          value: _isSelected,
                          onChanged: (_) {
                            if (_isSelected) {
                              removePiLab(_piLab.id);
                            } else {
                              addPiLab(_piLab.id);
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
