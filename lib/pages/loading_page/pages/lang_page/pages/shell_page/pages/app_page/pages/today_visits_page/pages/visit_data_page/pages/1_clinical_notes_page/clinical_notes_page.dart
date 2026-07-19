import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/patient_form_item.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_forms.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class VisitClinicalNotesPage extends StatelessWidget {
  const VisitClinicalNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxVisitData, PxPatientForms, PxLocale>(
      builder: (context, vd, pf, l, _) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              while (vd.result == null || pf.result == null) {
                return const CentralLoading();
              }

              while (vd.result is ApiErrorResult ||
                  pf.result is ApiErrorResult) {
                return CentralError(
                  code: (vd.result as ApiErrorResult).errorCode,
                  toExecute: () async {
                    await Future.wait(
                      [
                        vd.retry(),
                        pf.retry(),
                      ],
                    );
                  },
                );
              }

              ///TODO: clinical notes empty - first visit

              //TODO: craft UI
              final _patientForms =
                  (pf.result as ApiDataResult<List<PatientFormItem>>).data;
              return Column(
                children: [
                  VisitDetailsPageInfoHeader(
                    patient:
                        (vd.result as ApiDataResult<VisitData>).data.patient,
                    title: context.loc.clinicalNotes,
                    iconData: Icons.edit_document,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        if (_patientForms.isNotEmpty) ...[
                          ..._patientForms.map((form) {
                            final _index = _patientForms.indexOf(form);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card.outlined(
                                elevation: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    titleAlignment: ListTileTitleAlignment.top,
                                    leading: SmBtn(
                                      child: Text('${_index + 1}'),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text.rich(
                                        TextSpan(
                                          text: '',
                                          children: [
                                            ...form.form_data.map((data) {
                                              return TextSpan(
                                                text: '',
                                                children: [
                                                  TextSpan(text: '* '),
                                                  TextSpan(
                                                    text: data.field_name,
                                                    style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ': ${data.field_value}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\n\n',
                                                  ),
                                                ],
                                              );
                                            }),
                                          ],
                                        ),
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          const Divider(),
                        ],

                        ///rest of progress notes
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
