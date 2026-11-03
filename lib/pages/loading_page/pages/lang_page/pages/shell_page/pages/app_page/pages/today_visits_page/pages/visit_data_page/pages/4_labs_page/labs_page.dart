import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/doctor_items/pi_lab.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_labs.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class VisitLabsPage extends StatefulWidget {
  const VisitLabsPage({super.key});

  @override
  State<VisitLabsPage> createState() => _VisitLabsPageState();
}

class _VisitLabsPageState extends State<VisitLabsPage> {
  final ValueNotifier<bool> _isPresetsVisible = ValueNotifier<bool>(true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<PxPiLabs, PxVisitData, PxLocale>(
        builder: (context, lb, v, l, _) {
          return Builder(
            builder: (context) {
              while (v.result == null || lb.labs == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult || lb.labs is ApiErrorResult) {
                return CentralError(
                  code: (v.result as ApiErrorResult).errorCode,
                  toExecute: () async {
                    v.retry();
                    lb.retry();
                  },
                );
              }
              final _piLabs =
                  (lb.filteredLabs as ApiDataResult<List<PiLab>>).data;

              final _data = (v.result as ApiDataResult<VisitData>).data;

              final _visit_labs = _data.labs;

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
                                    //TODO
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
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade200,
                                  ),
                                  onPressed: () {
                                    //TODO
                                  },
                                  label: Text(context.loc.save),
                                  icon: const Icon(Icons.save),
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
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          flex: 3,
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
                                          await v.removeLabFromVisitData(
                                            _piLab.id,
                                          );
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
                        const VerticalDivider(),
                        Expanded(
                          flex: 1,
                          child: Card.outlined(),
                        ),
                      ],
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
