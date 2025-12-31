import 'package:one/core/api/_api_result.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/doctor.dart';
import 'package:one/models/visits/visits_filter.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_filter.dart';
import 'package:provider/provider.dart';

class VisitsFilterHeader extends StatefulWidget {
  const VisitsFilterHeader({super.key});

  @override
  State<VisitsFilterHeader> createState() => _VisitsFilterHeaderState();
}

class _VisitsFilterHeaderState extends State<VisitsFilterHeader> {
  late final TextEditingController _fromController;
  late final TextEditingController _toController;
  final ValueNotifier<Doctor?> _docNotifier = ValueNotifier(null);
  final ValueNotifier<Clinic?> _clinicNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    final _s = context.read<PxVisitFilter>();
    final _l = context.read<PxLocale>();
    _fromController = TextEditingController(
      text: DateFormat('dd - MM - yyyy', _l.lang).format(_s.from),
    );
    _toController = TextEditingController(
      text: DateFormat('dd - MM - yyyy', _l.lang).format(_s.to),
    );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer2<PxVisitFilter, PxLocale>(
        builder: (context, v, l, _) {
          return ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Text(context.loc.visits)),
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Text(context.loc.from),
                        Text(' : '),
                        Text(
                          DateFormat('dd - MM - yyyy', l.lang).format(v.from),
                          style: TextStyle(color: Colors.red),
                        ),
                        Text('  '),
                        Text(context.loc.to),
                        Text(' : '),
                        Text(
                          DateFormat('dd - MM - yyyy', l.lang).format(v.to),
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Builder(
                    builder: (context) {
                      while (v.concisedVisits == null) {
                        return CupertinoActivityIndicator();
                      }
                      final _length = v.filteredConcisedVisits.length;
                      return Text('($_length)'.toArabicNumber(context));
                    },
                  ),
                ],
              ),
            ),
            subtitle: const Divider(),
            children: [
              Row(
                spacing: 8,
                children: [
                  Text(context.loc.from),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: _fromController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SmBtn(
                    tooltip: context.loc.pickStartingDate,
                    onPressed: () async {
                      final _from = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().copyWith(
                          year: DateTime.now().year - 5,
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (_from != null) {
                        _fromController.text = DateFormat(
                          'dd - MM - yyyy',
                          l.lang,
                        ).format(_from);
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await v.changeDate(from: _from, to: v.to);
                            },
                          );
                        }
                      }
                    },
                    child: const Icon(Icons.calendar_month_rounded),
                  ),
                  Text(context.loc.to),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: _toController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SmBtn(
                    tooltip: context.loc.pickEndingDate,
                    onPressed: () async {
                      final _to = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().copyWith(
                          year: DateTime.now().year - 5,
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (_to != null) {
                        _toController.text = DateFormat(
                          'dd - MM - yyyy',
                          l.lang,
                        ).format(_to);
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await v.changeDate(from: v.from, to: _to);
                            },
                          );
                        }
                      }
                    },
                    child: const Icon(Icons.calendar_month_rounded),
                  ),
                ],
              ),
              SizedBox(height: 4),
              if (PxAuth.isLoggedInUserSuperAdmin(context))
                Card.outlined(
                  elevation: 0,
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                    side: BorderSide(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        const Icon(Icons.filter_alt_rounded),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 8.0),
                        //   child: Text(context.loc.filterVisits),
                        // ),
                        ...VisitsFilter.values.map((filter) {
                          return FilterChip.elevated(
                            label: Text(l.isEnglish ? filter.en : filter.ar),
                            onSelected: (value) {
                              v.filterVisits(filter, '');
                            },
                            selected: v.filter == filter,
                            selectedColor: Colors.amber.shade50,
                          );
                        }),
                        switch (v.filter) {
                          VisitsFilter.no_filter => SizedBox(),
                          VisitsFilter.by_doctor => Consumer<PxDoctor>(
                            builder: (context, d, _) {
                              while (d.allDoctors == null) {
                                return const SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: LinearProgressIndicator(),
                                );
                              }
                              final _doctors = d.allDoctors;
                              return ValueListenableBuilder<Doctor?>(
                                valueListenable: _docNotifier,
                                builder: (context, value, child) {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<Doctor>(
                                      isExpanded: true,
                                      alignment: Alignment.center,
                                      hint: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(context.loc.pickDoctor),
                                        ],
                                      ),
                                      items: [
                                        if (_doctors != null)
                                          ..._doctors.map((doc) {
                                            return DropdownMenuItem<Doctor>(
                                              alignment: Alignment.center,
                                              value: doc,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    l.isEnglish
                                                        ? doc.name_en
                                                        : doc.name_ar,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                      ],
                                      initialValue: _docNotifier.value,
                                      onChanged: (val) {
                                        if (val != null) {
                                          _docNotifier.value = val;
                                          v.filterVisits(
                                            VisitsFilter.by_doctor,
                                            val.id,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          VisitsFilter.by_clinic => Consumer<PxClinics>(
                            builder: (context, c, _) {
                              while (c.result == null) {
                                return const SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: LinearProgressIndicator(),
                                );
                              }
                              final _clinics =
                                  (c.result as ApiDataResult<List<Clinic>>)
                                      .data;
                              return ValueListenableBuilder<Clinic?>(
                                valueListenable: _clinicNotifier,
                                builder: (context, value, child) {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<Clinic>(
                                      isExpanded: true,
                                      alignment: Alignment.center,
                                      hint: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(context.loc.pickClinic),
                                        ],
                                      ),
                                      initialValue: _clinicNotifier.value,
                                      items: [
                                        ..._clinics.map((clinic) {
                                          return DropdownMenuItem<Clinic>(
                                            alignment: Alignment.center,
                                            value: clinic,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  l.isEnglish
                                                      ? clinic.name_en
                                                      : clinic.name_ar,
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) {
                                          _clinicNotifier.value = val;
                                          v.filterVisits(
                                            VisitsFilter.by_clinic,
                                            val.id,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        },
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
