import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/logic/client_notification_formatter_sender.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/doctor_items/pi_procedure.dart';
import 'package:one/models/notifications/in_app_action.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_procedures.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class VisitProceduresPage extends StatelessWidget {
  const VisitProceduresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer4<PxPiProcedures, PxVisits, PxVisitData, PxLocale>(
        builder: (context, p, vs, v, l, _) {
          return Builder(
            builder: (context) {
              while (v.result == null ||
                  p.procedures == null ||
                  vs.visits == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult ||
                  p.procedures is ApiErrorResult ||
                  vs.visits is ApiErrorResult) {
                return CentralError(
                  code: (v.result as ApiErrorResult).errorCode,
                  toExecute: () async {
                    v.retry();
                    p.retry();
                    vs.retry();
                  },
                );
              }
              final _doctor_procedures =
                  (p.filteredProcedures as ApiDataResult<List<PiProcedure>>)
                      .data;

              final _data = (v.result as ApiDataResult<VisitData>).data;

              final _visit_procedures = _data.procedures;

              final _visits =
                  (vs.visits as ApiDataResult<List<VisitExpanded>>).data;

              final _visit = _visits.firstWhereOrNull(
                (e) => e.id == _data.visit_id,
              );
              return Column(
                children: [
                  Builder(
                    builder: (context) {
                      return VisitDetailsPageInfoHeader(
                        patient:
                            (v.result as ApiDataResult<VisitData>).data.patient,
                        title: context.loc.visitProcedures,
                        iconData: FontAwesomeIcons.userDoctor,
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
                                p.searchForItems(value);
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
                                p.clearSearch();
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
                      itemCount: _doctor_procedures.length,
                      itemBuilder: (context, index) {
                        final _piProcedure = _doctor_procedures[index];
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
                                          ? _piProcedure.name_en
                                          : _piProcedure.name_ar,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            value: _visit_procedures.contains(_piProcedure),
                            onChanged: (value) async {
                              await shellFunction(
                                context,
                                toExecute: () async {
                                  final _toAdd = _visit_procedures.contains(
                                    _piProcedure,
                                  );
                                  if (_toAdd) {
                                    await v.removeProcedureFromVisitData(
                                      _piProcedure.id,
                                    );
                                  } else {
                                    await v.addProcedureToVisitData(
                                      _piProcedure.id,
                                    );
                                  }
                                  if (context.mounted) {
                                    ClientNotificationFormatterSender(
                                        organizationExpanded: context
                                            .read<PxAuth>()
                                            .organization!,
                                        isEnglish: context
                                            .read<PxLocale>()
                                            .isEnglish,
                                      )
                                      ..formatFromInAppAction(
                                        action: _toAdd
                                            ? InAppAction
                                                  .remove_procedure_from_visit
                                            : InAppAction
                                                  .add_procedure_to_visit,
                                        account_types:
                                            context
                                                .read<PxAppConstants>()
                                                .constants
                                                ?.accountTypes ??
                                            [],
                                        patient_name: _visit?.patient.name,
                                        doctor_name: l.isEnglish
                                            ? _visit?.doctor.name_en
                                            : _visit?.doctor.name_ar,
                                        procedure_name: l.isEnglish
                                            ? _piProcedure.name_en
                                            : _piProcedure.name_ar,
                                        procedure_amount: _piProcedure.price
                                            .toString(),
                                      )
                                      ..send();
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
