import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/pi_rads.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:provider/provider.dart';

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

class PreviousVisitsSummary extends StatefulWidget {
  const PreviousVisitsSummary({super.key});

  @override
  State<PreviousVisitsSummary> createState() => _PreviousVisitsSummaryState();
}

class _PreviousVisitsSummaryState extends State<PreviousVisitsSummary> {
  final ValueNotifier<Set<String>> _selectedBtnSegment = ValueNotifier({
    'drugs',
  });

  late final l = context.read<PxLocale>();
  late final vd = context.read<PxVisitData>();

  late final _previousDrugs = vd.drugData;

  late final _previousDiagnoses = vd.diagnosisData;

  late final _previousLabs = vd.labData;

  late final _previousRads = vd.radData;

  late final _previousprocedures = vd.procedureData;

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
                        title: Text.rich(
                          TextSpan(
                            text:
                                '(${_index + 1}) ${intl.DateFormat(
                                  'dd - MM - yyyy',
                                  l.lang,
                                ).format(entry.key)}',
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_previousDiagnoses?[entry.key] != null &&
                                _previousDiagnoses![entry.key]!.isNotEmpty) ...[
                              Divider(
                                color: Colors.blue.shade200,
                              ),
                              Text(
                                '${context.loc.diagnosis} : (${_previousDiagnoses[entry.key]})',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Divider(
                                color: Colors.blue.shade200,
                              ),
                            ],
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
                    final _index = _previousprocedures.keys.toList().indexOf(
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
