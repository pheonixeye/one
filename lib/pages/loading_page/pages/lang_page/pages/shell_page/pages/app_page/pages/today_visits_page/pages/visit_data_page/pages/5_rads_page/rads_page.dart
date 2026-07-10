import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/doctor_items/pi_rads.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_rads.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class VisitRadsPage extends StatelessWidget {
  const VisitRadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<PxPiRads, PxVisitData, PxLocale>(
        builder: (context, r, v, l, _) {
          return Builder(
            builder: (context) {
              while (v.result == null || r.rads == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult || r.rads is ApiErrorResult) {
                return CentralError(
                  code: (v.result as ApiErrorResult).errorCode,
                  toExecute: () async {
                    v.retry();
                    r.retry();
                  },
                );
              }
              final _piRads =
                  (r.filteredRads as ApiDataResult<List<PiRad>>).data;

              final _data = (v.result as ApiDataResult<VisitData>).data;

              final _visit_rads = _data.rads;

              return Column(
                children: [
                  Builder(
                    builder: (context) {
                      return VisitDetailsPageInfoHeader(
                        patient:
                            (v.result as ApiDataResult<VisitData>).data.patient,
                        title: context.loc.visitRads,
                        iconData: FontAwesomeIcons.radiation,
                      );
                    },
                  ),
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
                                hintText:
                                    context.loc.searchByEnglishOrArabicItemName,
                              ),
                              onChanged: (value) {
                                r.searchForItems(value);
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
                                r.clearSearch();
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
                      itemCount: _piRads.length,
                      itemBuilder: (context, index) {
                        final _piRad = _piRads[index];
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
                                          ? _piRad.name_en
                                          : _piRad.name_ar,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            value: _visit_rads.contains(_piRad),
                            onChanged: (value) async {
                              await shellFunction(
                                context,
                                toExecute: () async {
                                  if (_visit_rads.contains(_piRad)) {
                                    await v.removeRadFromVisitData(_piRad.id);
                                  } else {
                                    await v.addRadToVisitData(_piRad.id);
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
            },
          );
        },
      ),
    );
  }
}
