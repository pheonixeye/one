import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/datetime_ext.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient_progress_note.dart';
import 'package:one/models/patient_form_item.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/1_progress_notes_page/progress_notes_card.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_forms.dart';
import 'package:one/providers/px_progress_notes.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class VisitProgressNotesPage extends StatefulWidget {
  const VisitProgressNotesPage({super.key});

  @override
  State<VisitProgressNotesPage> createState() => _VisitProgressNotesPageState();
}

class _VisitProgressNotesPageState extends State<VisitProgressNotesPage> {
  late final ScrollController _scrollController;
  late final PxProgressNotes _pxPn;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pxPn = context.read<PxProgressNotes>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.8 &&
          !_pxPn.isLoading) {
        _pxPn.fetchNextBatch();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<PxVisitData, PxPatientForms, PxProgressNotes, PxLocale>(
      builder: (context, vd, pf, pn, l, _) {
        while (vd.result == null || pf.result == null || pn.result == null) {
          return const CentralLoading();
        }

        while (vd.result is ApiErrorResult ||
            pf.result is ApiErrorResult ||
            pn.result is ApiErrorResult) {
          return CentralError(
            code: (vd.result as ApiErrorResult).errorCode,
            toExecute: () async {
              await Future.wait(
                [
                  vd.retry(),
                  pf.retry(),
                  pn.retry(),
                ],
              );
            },
          );
        }
        final _visit_data = (vd.result as ApiDataResult<VisitData>).data;

        final _patientForms =
            (pf.result as ApiDataResult<List<PatientFormItem>>).data;

        final _notes = pn.notes;

        return Scaffold(
          body: Column(
            children: [
              if (pn.isLoading)
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              VisitDetailsPageInfoHeader(
                patient: (vd.result as ApiDataResult<VisitData>).data.patient,
                title: context.loc.clinicalNotes,
                iconData: Icons.edit_document,
              ),
              Expanded(
                child: ListView(
                  cacheExtent: 3000,
                  controller: _scrollController,
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
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ': ${data.field_value}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
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
                    if (_notes.isNotEmpty)
                      ..._notes.map((note) {
                        final _index = _notes.indexOf(note);
                        return ProgressNotesCard(
                          note: note,
                          index: _index,
                        );
                      })
                    else
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 80,
                          right: 80,
                          top: 60,
                        ),
                        child: Card.outlined(
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              spacing: 8,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.loc.noProgressNotesFound,
                                  textAlign: TextAlign.center,
                                ),
                                const Icon(Icons.info),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: SmBtn(
            tooltip: context.loc.addClinicalProgressNote,
            onPressed: () async {
              await shellFunction(
                context,
                toExecute: () async {
                  final _now = DateTime.now();
                  final _note = PatientProgressNote(
                    id: '',
                    patient_id: _visit_data.patient.id,
                    visit_id: _visit_data.visit_id,
                    doc_id: '${_visit_data.doctor?.id}',
                    clinic_id: _visit_data.clinic_id,
                    subjective: '',
                    objective: '',
                    assessment: '',
                    plan: '',
                    visit_date: _visit_data.visit?.visit_date ?? _now.unTimed,
                    time_of_note: _now,
                  );
                  await pn.createNote(_note);
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
