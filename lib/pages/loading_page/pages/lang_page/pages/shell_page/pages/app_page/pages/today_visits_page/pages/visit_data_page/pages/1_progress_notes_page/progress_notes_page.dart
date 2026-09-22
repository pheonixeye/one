import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:one/models/doctor_items/pi_rads.dart';
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
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';

class _btnSegData {
  final Icon icon;
  final String value;
  const _btnSegData({
    required this.icon,
    required this.value,
  });
}

final List<_btnSegData> _btnSegments = const [
  _btnSegData(
    value: 'drugs',
    icon: Icon(
      FontAwesomeIcons.prescriptionBottle,
    ),
  ),
  _btnSegData(
    value: 'labs',
    icon: Icon(
      FontAwesomeIcons.droplet,
    ),
  ),
  _btnSegData(
    value: 'rads',
    icon: Icon(
      FontAwesomeIcons.radiation,
    ),
  ),
  _btnSegData(
    value: 'procedures',
    icon: Icon(
      FontAwesomeIcons.kitMedical,
    ),
  ),
];

class VisitProgressNotesPage extends StatefulWidget {
  const VisitProgressNotesPage({super.key});

  @override
  State<VisitProgressNotesPage> createState() => _VisitProgressNotesPageState();
}

class _VisitProgressNotesPageState extends State<VisitProgressNotesPage> {
  late final ScrollController _scrollController;
  late final PxProgressNotes _pxPn;
  final ValueNotifier<Set<String>> _selectedBtnSegment = ValueNotifier({
    'drugs',
  });
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

        final _previousDrugs = vd.drugData;

        final _previousLabs = vd.labData;

        final _previousRads = vd.radData;

        final _previousprocedures = vd.procedureData;

        List<Widget> _buildPreviousAccordingToValue(String value) {
          return switch (value) {
            'drugs' =>
              _previousDrugs != null
                  ? [
                      ..._previousDrugs.entries.map((
                        entry,
                      ) {
                        final _index = _previousDrugs.keys.toList().indexOf(
                          entry.key,
                        );
                        return Card.outlined(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            child: ListTile(
                              title: Text(
                                '(${_index + 1}) ${intl.DateFormat(
                                  'dd - MM - yyyy',
                                  l.lang,
                                ).format(entry.key)}',
                              ),
                              subtitle: Column(
                                children: [
                                  if (entry.value.entries.isEmpty)
                                    Text(
                                      context.loc.noDrugsWerePrescribed,
                                    ),
                                  ...entry.value.entries.map((
                                    e2,
                                  ) {
                                    return Text.rich(
                                      TextSpan(
                                        text: "* ${e2.key.prescriptionNameEn}",
                                        children: [
                                          TextSpan(
                                            text: '\n',
                                          ),
                                          TextSpan(
                                            text: e2.value,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ]
                  : [],
            'labs' =>
              _previousLabs != null
                  ? [
                      ..._previousLabs.entries.map(
                        (entry) {
                          final _index = _previousLabs.keys.toList().indexOf(
                            entry.key,
                          );
                          return Card.outlined(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  '(${_index + 1}) ${intl.DateFormat(
                                    'dd - MM - yyyy',
                                    l.lang,
                                  ).format(entry.key)}',
                                ),
                                subtitle: Column(
                                  children: [
                                    if (entry.value.isEmpty)
                                      Text(
                                        context.loc.noLabsWereRequested,
                                      ),
                                    ...entry.value.map(
                                      (v) => Text.rich(
                                        TextSpan(
                                          text:
                                              '* ${l.isEnglish ? v.name_en : v.name_ar}',
                                          children: [
                                            TextSpan(text: '\n'),
                                            TextSpan(
                                              text: v.special_instructions,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ]
                  : [],
            'rads' =>
              _previousRads != null
                  ? [
                      ..._previousRads.entries.map(
                        (entry) {
                          final _index = _previousRads.keys.toList().indexOf(
                            entry.key,
                          );
                          return Card.outlined(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  '(${_index + 1}) ${intl.DateFormat(
                                    'dd - MM - yyyy',
                                    l.lang,
                                  ).format(entry.key)}',
                                ),
                                subtitle: Column(
                                  children: [
                                    if (entry.value.isEmpty)
                                      Text(
                                        context.loc.noRadsWereRequested,
                                      ),
                                    ...entry.value.map(
                                      (v) => Text.rich(
                                        TextSpan(
                                          text: l.isEnglish
                                              ? '* ${v.name_en} (${v.type.localizedString(
                                                  l.isEnglish,
                                                )})'
                                              : '* ${v.name_ar} (${v.type.localizedString(
                                                  l.isEnglish,
                                                )})',
                                          children: [
                                            TextSpan(text: '\n'),
                                            TextSpan(
                                              text: v.special_instructions,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ]
                  : [],
            'procedures' =>
              _previousprocedures != null
                  ? [
                      ..._previousprocedures.entries.map(
                        (entry) {
                          final _index = _previousprocedures.keys
                              .toList()
                              .indexOf(
                                entry.key,
                              );
                          return Card.outlined(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  '(${_index + 1}) ${intl.DateFormat(
                                    'dd - MM - yyyy',
                                    l.lang,
                                  ).format(entry.key)}',
                                ),
                                subtitle: Column(
                                  children: [
                                    if (entry.value.isEmpty)
                                      Text(
                                        context.loc.noProceduresWerePerformed,
                                      ),
                                    ...entry.value.map(
                                      (v) => Text.rich(
                                        TextSpan(
                                          text:
                                              '* ${l.isEnglish ? v.name_en : v.name_ar}',
                                          children: [
                                            TextSpan(text: '\n'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ]
                  : [],
            _ => [],
          };
        }

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
                                    final _index = _patientForms.indexOf(form);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card.outlined(
                                        elevation: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            titleAlignment:
                                                ListTileTitleAlignment.top,
                                            leading: SmBtn(
                                              child: Text('${_index + 1}'),
                                            ),
                                            trailing: SmBtn(
                                              tooltip: context.loc.deleteForm,
                                              backgroundColor: Colors.red,
                                              onPressed: () async {
                                                final _confirmDeleteForm =
                                                    await showDialog<bool?>(
                                                      context: context,
                                                      builder: (context) {
                                                        return PromptDialog(
                                                          message: context
                                                              .loc
                                                              .confirmDeleteForm,
                                                        );
                                                      },
                                                    );
                                                if (_confirmDeleteForm ==
                                                        null ||
                                                    _confirmDeleteForm ==
                                                        false) {
                                                  return;
                                                }
                                                if (context.mounted) {
                                                  await shellFunction(
                                                    context,
                                                    toExecute: () async {
                                                      await pf
                                                          .detachFormFromPatient(
                                                            form,
                                                          );
                                                    },
                                                  );
                                                }
                                              },
                                              child: const Icon(
                                                Icons.delete_forever,
                                              ),
                                            ),
                                            title: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Text.rich(
                                                TextSpan(
                                                  text: '',
                                                  children: [
                                                    ...form.form_data.map((
                                                      data,
                                                    ) {
                                                      return TextSpan(
                                                        text: '',
                                                        children: [
                                                          TextSpan(text: '* '),
                                                          TextSpan(
                                                            text:
                                                                data.field_name,
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                ': ${data.field_value}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
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
                                                textDirection:
                                                    TextDirection.ltr,
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
                    if (!context.isMobile)
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ValueListenableBuilder(
                            valueListenable: _selectedBtnSegment,
                            builder: (context, value, child) {
                              return Column(
                                children: [
                                  SegmentedButton<String>(
                                    style: SegmentedButton.styleFrom(
                                      selectedBackgroundColor: Colors.amber,
                                    ),
                                    showSelectedIcon: false,
                                    segments: [
                                      ..._btnSegments.map(
                                        (e) => ButtonSegment(
                                          value: e.value,
                                          icon: e.icon,
                                        ),
                                      ),
                                    ],
                                    onSelectionChanged: (val) {
                                      _selectedBtnSegment.value = val;
                                    },
                                    selected: value,
                                  ),
                                  const SizedBox(height: 4),
                                  const Divider(
                                    height: 2,
                                    thickness: 2,
                                  ),
                                  Expanded(
                                    child: ListView(
                                      children: [
                                        switch (value.first) {
                                          'drugs' => Text(
                                            '${context.loc.previous}  ${context.loc.visitDrugs}',
                                          ),
                                          'labs' => Text(
                                            '${context.loc.previous}  ${context.loc.visitLabs}',
                                          ),
                                          'rads' => Text(
                                            '${context.loc.previous}  ${context.loc.visitRads}',
                                          ),
                                          'procedures' => Text(
                                            '${context.loc.previous}  ${context.loc.visitProcedures}',
                                          ),
                                          _ => SizedBox(),
                                        },
                                        ..._buildPreviousAccordingToValue(
                                          value.first,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
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
