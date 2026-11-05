import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/deep_list_equality.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/doctor_items/pi_lab.dart';
import 'package:one/models/preset.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/4_labs_page/widgets/preset_create_edit_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_presets.dart';
import 'package:one/providers/px_profile_items/px_pi_labs.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class VisitLabsPage extends StatefulWidget {
  const VisitLabsPage({super.key});

  @override
  State<VisitLabsPage> createState() => _VisitLabsPageState();
}

class _VisitLabsPageState extends State<VisitLabsPage>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _isPresetsVisible = ValueNotifier<bool>(true);

  final ValueNotifier<List<String>> _visitLabsState =
      ValueNotifier<List<String>>(
        [],
      );

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  )..repeat(reverse: true); // Repeats back and forth indefinitely

  late final _colorAnimation = ColorTween(
    begin: Colors.white,
    end: Colors.red,
  ).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addPiLab(String id) {
    _visitLabsState.value = [..._visitLabsState.value, id];
  }

  void _removePiLab(String id) {
    final _current = _visitLabsState.value;
    final _index = _current.indexOf(id);
    _current.removeAt(_index);
    _visitLabsState.value = [..._current];
  }

  void _setPiLabsFromPreset(List<String> labsIds) {
    _visitLabsState.value = [...labsIds];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer4<PxPiLabs, PxVisitData, PxPresets, PxLocale>(
        builder: (context, lb, v, p, l, _) {
          return Builder(
            builder: (context) {
              while (v.result == null || lb.labs == null || p.result == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult ||
                  lb.labs is ApiErrorResult ||
                  p.result is ApiErrorResult) {
                return CentralError(
                  code: (v.result as ApiErrorResult).errorCode,
                  toExecute: () async {
                    v.retry();
                    lb.retry();
                    p.retry();
                  },
                );
              }
              final _piLabs =
                  (lb.filteredLabs as ApiDataResult<List<PiLab>>).data;

              final _presets = (p.result as ApiDataResult<List<Preset>>).data;

              final _labPresets = _presets
                  .where((e) => e.type == PresetType.lab)
                  .toList();

              final _data = (v.result as ApiDataResult<VisitData>).data;

              final _visit_labs = _data.labs;

              _visitLabsState.value = [
                ..._visit_labs.map((l) => l.id),
              ];

              final _infoHeader = Builder(
                builder: (context) {
                  return VisitDetailsPageInfoHeader(
                    patient:
                        (v.result as ApiDataResult<VisitData>).data.patient,
                    title: context.loc.visitLabs,
                    iconData: FontAwesomeIcons.droplet,
                  );
                },
              );

              if (context.isMobile) {
                return Column(
                  children: [
                    _infoHeader,
                    Card.outlined(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: context
                                      .loc
                                      .searchByEnglishOrArabicItemName,
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
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _piLabs.length,
                        itemBuilder: (context, index) {
                          final _piLab = _piLabs[index];
                          return Card.outlined(
                            elevation: 6,
                            child: CheckboxListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                              value: _visit_labs.contains(_piLab),
                              onChanged: (value) async {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    if (_visit_labs.contains(_piLab)) {
                                      await v.removeLabFromVisitData(_piLab.id);
                                    } else {
                                      await v.addLabToVisitData(_piLab.id);
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return Column(
                spacing: 8,
                children: [
                  _infoHeader,
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
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: context
                                      .loc
                                      .searchByEnglishOrArabicItemName,
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
                              child: Tooltip(
                                message: context.loc.clearSearch,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade200,
                                  ),
                                  onPressed: () {
                                    lb.clearSearch();
                                  },
                                  label: Text(context.loc.refresh),
                                  icon: const Icon(Icons.refresh),
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
                                    _isPresetsVisible.value =
                                        !_isPresetsVisible.value;
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
                                  valueListenable: _visitLabsState,
                                  builder: (context, _, child) {
                                    final _isStateSaved = _visitLabsState.value
                                        .isDeeplyEqualTo([
                                          ..._visit_labs.map((l) => l.id),
                                        ]);
                                    return ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade200,
                                      ),
                                      onPressed: () async {
                                        await shellFunction(
                                          context,
                                          toExecute: () async {
                                            await v.setLabsOfVisitData(
                                              visit_data_id: _data.id,
                                              labs_ids: _visitLabsState.value,
                                            );
                                          },
                                        );
                                      },
                                      label: Text(context.loc.save),
                                      icon: _isStateSaved
                                          ? const Icon(Icons.save)
                                          : AnimatedBuilder(
                                              animation: _colorAnimation,
                                              builder: (context, child) {
                                                return Icon(
                                                  Icons.save,
                                                  color: _colorAnimation.value,
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
                        valueListenable: _isPresetsVisible,
                        builder: (context, _, _) {
                          return Row(
                            spacing: 8,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ValueListenableBuilder(
                                  valueListenable: _visitLabsState,
                                  builder: (context, _, _) {
                                    return ListView.builder(
                                      itemCount: _piLabs.length,
                                      itemBuilder: (context, index) {
                                        final _piLab = _piLabs[index];
                                        final _isSelected = _visitLabsState
                                            .value
                                            .contains(_piLab.id);
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
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                    child: SmBtn(
                                                      child: Text(
                                                        '${index + 1}'
                                                            .toArabicNumber(
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
                                                _removePiLab(_piLab.id);
                                              } else {
                                                _addPiLab(_piLab.id);
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              if (_isPresetsVisible.value == true) ...[
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
                                                _setPiLabsFromPreset([]);
                                                _setPiLabsFromPreset([
                                                  ..._visit_labs.map(
                                                    (e) => e.id,
                                                  ),
                                                ]);
                                              },
                                              icon: const Icon(Icons.refresh),
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
                                            valueListenable: _visitLabsState,
                                            builder: (context, _, _) {
                                              return ListView(
                                                children: [
                                                  ..._labPresets.map((preset) {
                                                    final index = _labPresets
                                                        .indexOf(preset);
                                                    final _isPresetSelected =
                                                        _visitLabsState.value
                                                            .isDeeplyEqualTo(
                                                              preset.preset
                                                                  as List<
                                                                    String
                                                                  >,
                                                            );

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4.0,
                                                          ),
                                                      child: Card.outlined(
                                                        color: _isPresetSelected
                                                            ? Colors
                                                                  .blue
                                                                  .shade200
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
                                                                _setPiLabsFromPreset(
                                                                  [],
                                                                );
                                                              } else {
                                                                _setPiLabsFromPreset(
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
                                                                              message: context.loc.deletePresetPrompt,
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
                                                                      await p.deletePreset(
                                                                        preset
                                                                            .id,
                                                                      );
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              final _preset =
                                                  await showDialog<Preset?>(
                                                    context: context,
                                                    builder: (context) {
                                                      return PresetCreateEditDialog(
                                                        type: PresetType.lab,
                                                        selectedLabs: [
                                                          ..._visitLabsState
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
        },
      ),
    );
  }
}
