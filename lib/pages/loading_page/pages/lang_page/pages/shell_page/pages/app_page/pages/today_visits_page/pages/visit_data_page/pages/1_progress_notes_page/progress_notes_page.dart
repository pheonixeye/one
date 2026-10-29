import 'package:flutter/material.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/1_progress_notes_page/clinical_form_card.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/1_progress_notes_page/previous_visits_summary.dart';
import 'package:provider/provider.dart';

import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/datetime_ext.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient_form_item.dart';
import 'package:one/models/patient_progress_note.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/patient_forms_dialog/patient_forms_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/1_progress_notes_page/progress_notes_card.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_forms.dart';
import 'package:one/providers/px_progress_notes.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';

class VisitProgressNotesPage extends StatefulWidget {
  const VisitProgressNotesPage({super.key});

  @override
  State<VisitProgressNotesPage> createState() => _VisitProgressNotesPageState();
}

class _VisitProgressNotesPageState extends State<VisitProgressNotesPage> {
  late final ScrollController _scrollController;
  late final PxProgressNotes _pxPn;
  late final PxVisitData _pxVisitData;

  final ValueNotifier<bool> _isEditingDiagnosis = ValueNotifier<bool>(false);
  late final TextEditingController _diagnosisController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pxPn = context.read<PxProgressNotes>();
    _pxVisitData = context.read<PxVisitData>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.8 &&
          !_pxPn.isLoading) {
        _pxPn.fetchNextBatch();
      }
    });
    _diagnosisController = TextEditingController();
    if (_pxVisitData.result != null) {
      final _r = (_pxVisitData.result as ApiDataResult<VisitData>).data;
      _diagnosisController.text = _r.diagnosis;
    }
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
                child: Row(
                  spacing: 8,
                  children: [
                    //patient forms and progress notes
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              cacheExtent: 3000,
                              controller: _scrollController,
                              children: [
                                if (_patientForms.isEmpty)
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              context.loc.noFormsFound,
                                              textAlign: TextAlign.center,
                                            ),
                                            const Icon(Icons.info),
                                            SmBtn(
                                              tooltip: context.loc.addNewForm,
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return ChangeNotifierProvider.value(
                                                      value: pf,
                                                      child:
                                                          const PatientFormsDialog(),
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_patientForms.isNotEmpty) ...[
                                  ..._patientForms.map((form) {
                                    if (!form.presentable_in_clinical_notes) {
                                      return const SizedBox();
                                    }
                                    return ClinicalFormCard(form: form);
                                  }),
                                  const Divider(),
                                ],
                                //diagnosis card
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ValueListenableBuilder(
                                    valueListenable: _isEditingDiagnosis,
                                    builder: (context, value, child) {
                                      return Card.outlined(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 8,
                                            children: [
                                              Text(
                                                context.loc.diagnosis,
                                                style: Theme.of(
                                                  context,
                                                ).listTileTheme.titleTextStyle,
                                              ),
                                              Row(
                                                children: [
                                                  if (value) ...[
                                                    Expanded(
                                                      child: TextFormField(
                                                        decoration: InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          enabled: true,
                                                        ),
                                                        maxLines: 1,
                                                        minLines: null,
                                                        expands: false,
                                                        controller:
                                                            _diagnosisController,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    SmBtn(
                                                      child: const Icon(
                                                        Icons.close,
                                                      ),
                                                      onPressed: () {
                                                        _isEditingDiagnosis
                                                                .value =
                                                            false;
                                                        _diagnosisController
                                                            .text = _visit_data
                                                            .diagnosis;
                                                      },
                                                    ),
                                                    const SizedBox(width: 10),
                                                    SmBtn(
                                                      child: const Icon(
                                                        Icons.save,
                                                      ),
                                                      onPressed: () async {
                                                        await shellFunction(
                                                          context,
                                                          toExecute: () async {
                                                            await vd.updateVisitDiagnosis(
                                                              _diagnosisController
                                                                  .text,
                                                            );
                                                          },
                                                          duration:
                                                              const Duration(
                                                                milliseconds:
                                                                    260,
                                                              ),
                                                        );
                                                        _isEditingDiagnosis
                                                                .value =
                                                            false;
                                                      },
                                                    ),
                                                    const SizedBox(width: 10),
                                                  ] else ...[
                                                    Expanded(
                                                      child: Text(
                                                        _visit_data.diagnosis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    SmBtn(
                                                      child: const Icon(
                                                        Icons.edit,
                                                      ),
                                                      onPressed: () {
                                                        _isEditingDiagnosis
                                                                .value =
                                                            true;
                                                        _diagnosisController
                                                            .text = _visit_data
                                                            .diagnosis;
                                                      },
                                                    ),
                                                    const SizedBox(width: 10),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const Divider(),

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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                    ),
                    if (!context.isMobile)
                      const VerticalDivider(
                        width: 2,
                        thickness: 2,
                      ),
                    //previous visit data summary
                    if (!context.isMobile) PreviousVisitsSummary(),
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
