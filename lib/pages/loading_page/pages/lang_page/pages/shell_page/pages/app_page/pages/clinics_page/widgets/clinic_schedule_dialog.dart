import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/clinic/clinic_schedule.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/select_weekday_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/visit_per_shift_dialog.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class ClinicScheduleDialog extends StatefulWidget {
  const ClinicScheduleDialog({super.key});

  @override
  State<ClinicScheduleDialog> createState() => _ClinicScheduleDialogState();
}

class _ClinicScheduleDialogState extends State<ClinicScheduleDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxClinics, PxLocale>(
      builder: (context, c, l, _) {
        while (c.clinic == null) {
          return const CentralLoading();
        }
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text(context.loc.clinicSchedule)),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          scrollable: false,
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: Builder(
            builder: (context) {
              return Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Scaffold(
                  floatingActionButton: SmBtn(
                    tooltip: _controller.index == 0
                        ? context.loc.addClinicDay
                        : context.loc.addDayShift,
                    onPressed: _controller.index == 0
                        ? () async {
                            final _intday = await showDialog<int?>(
                              context: context,
                              builder: (context) {
                                return SelectWeekdayDialog();
                              },
                            );
                            if (_intday == null) {
                              return;
                            }
                            if (context.mounted) {
                              await shellFunction(
                                context,
                                toExecute: () async {
                                  final _schedule = ClinicSchedule.initial(
                                    c.clinic!.id,
                                    _intday,
                                  );
                                  await c.addClinicSchedule(
                                    c.clinic!,
                                    _schedule,
                                  );
                                },
                              );
                            }
                          }
                        : () async {
                            await shellFunction(
                              context,
                              toExecute: () async {
                                if (c.clinicSchedule != null) {
                                  final _shift = ScheduleShift.initial();
                                  await c.addScheduleShift(
                                    c.clinic!,
                                    c.clinicSchedule!,
                                    _shift,
                                  );
                                }
                              },
                            );
                          },
                    child: const Icon(Icons.add),
                  ),
                  appBar: TabBar(
                    onTap: (value) {
                      if (value == 1) {
                        _controller.animateTo(0);
                        return;
                      } else {
                        c.setCliniSchedule(null);
                        return;
                      }
                    },
                    controller: _controller,
                    tabs: [
                      Tab(child: Text(context.loc.clinicDays)),
                      Tab(
                        child: Text(
                          c.clinicSchedule == null
                              ? context.loc.dayShifts
                              : '${l.isEnglish ? c.clinicSchedule?.weekday.en : c.clinicSchedule?.weekday.ar}',
                        ),
                      ),
                    ],
                  ),
                  body: TabBarView(
                    controller: _controller,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Builder(
                          builder: (context) {
                            final _items = c.clinic!.clinic_schedule;

                            return ListView.builder(
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                final _schedule = _items[index];
                                return Card.outlined(
                                  elevation: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: SmBtn(
                                        onPressed: null,
                                        child: Text('${index + 1}'),
                                      ),
                                      titleAlignment:
                                          ListTileTitleAlignment.center,
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              l.isEnglish
                                                  ? _schedule.weekday.en
                                                  : _schedule.weekday.ar,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: SmBtn(
                                              tooltip:
                                                  context.loc.deleteSchedule,
                                              onPressed: () async {
                                                final _toDeleteSchedule =
                                                    await showDialog<bool?>(
                                                      context: context,
                                                      builder: (context) {
                                                        return PromptDialog(
                                                          message: context
                                                              .loc
                                                              .deleteSchedulePrompt,
                                                        );
                                                      },
                                                    );
                                                if (_toDeleteSchedule == null ||
                                                    _toDeleteSchedule ==
                                                        false) {
                                                  return;
                                                }
                                                if (context.mounted) {
                                                  await shellFunction(
                                                    context,
                                                    toExecute: () async {
                                                      await c
                                                          .removeClinicSchedule(
                                                            c.clinic!,
                                                            _schedule,
                                                          );
                                                    },
                                                  );
                                                }
                                              },
                                              backgroundColor:
                                                  Colors.red.shade300,
                                              child: const Icon(
                                                Icons.delete_forever,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: SmBtn(
                                              onPressed: () {
                                                //todo: select clinicSchedule => show it's shifts
                                                c.setCliniSchedule(_schedule);
                                                _controller.animateTo(1);
                                              },
                                              child: const Icon(
                                                Icons.arrow_forward,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      //day shifts
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Builder(
                          builder: (context) {
                            while (c.clinicSchedule?.shifts == null) {
                              return const CentralLoading();
                            }
                            while (c.clinicSchedule?.shifts != null &&
                                c.clinicSchedule!.shifts.isEmpty) {
                              return CentralNoItems(
                                message: context.loc.noDayShiftsFound,
                              );
                            }
                            return ListView.builder(
                              itemCount: c.clinicSchedule?.shifts.length,
                              itemBuilder: (context, index) {
                                final _item = c.clinicSchedule!.shifts[index];
                                return Card.outlined(
                                  elevation: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: SmBtn(
                                        onPressed: null,
                                        child: Text('${index + 1}'),
                                      ),
                                      titleAlignment:
                                          ListTileTitleAlignment.top,
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _item.id.substring(0, 6),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: SmBtn(
                                              tooltip: context.loc.deleteShift,
                                              backgroundColor:
                                                  Colors.red.shade300,
                                              onPressed: () async {
                                                await shellFunction(
                                                  context,
                                                  toExecute: () async {
                                                    await c.removeScheduleShift(
                                                      c.clinic!,
                                                      c.clinicSchedule!,
                                                      _item,
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Icon(
                                                Icons.delete_forever,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 8,
                                          children: [
                                            const Divider(color: Colors.grey),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        context
                                                            .loc
                                                            .shiftStartingTime,
                                                      ),
                                                      Text(' '),
                                                      Text(
                                                        DateFormat.jm(
                                                          l.lang,
                                                        ).format(
                                                          DateTime.now()
                                                              .copyWith(
                                                                hour: _item
                                                                    .start_hour,
                                                                minute: _item
                                                                    .start_min,
                                                              ),
                                                        ),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: FloatingActionButton.small(
                                                    tooltip: context.loc.update,
                                                    heroTag:
                                                        '${_item.id}starting-time-picker',
                                                    child: const Icon(
                                                      Icons.more_time_rounded,
                                                    ),
                                                    onPressed: () async {
                                                      final _startingTime =
                                                          await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay.now(),
                                                          );
                                                      if (_startingTime ==
                                                          null) {
                                                        return;
                                                      }
                                                      if (context.mounted) {
                                                        final _toUpdateItem =
                                                            _item.copyWith(
                                                              start_hour:
                                                                  _startingTime
                                                                      .hour,
                                                              start_min:
                                                                  _startingTime
                                                                      .minute,
                                                            );
                                                        await shellFunction(
                                                          context,
                                                          toExecute: () async {
                                                            await c.updateScheduleShift(
                                                              c.clinic!,
                                                              c.clinicSchedule!,
                                                              _toUpdateItem,
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(color: Colors.grey),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        context
                                                            .loc
                                                            .shiftEndingTime,
                                                      ),
                                                      Text(' '),
                                                      Text(
                                                        DateFormat.jm(
                                                          l.lang,
                                                        ).format(
                                                          DateTime.now()
                                                              .copyWith(
                                                                hour: _item
                                                                    .end_hour,
                                                                minute: _item
                                                                    .end_min,
                                                              ),
                                                        ),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: FloatingActionButton.small(
                                                    tooltip: context.loc.update,
                                                    heroTag:
                                                        '${_item.id}end-time-picker',
                                                    child: const Icon(
                                                      Icons.timer_off_outlined,
                                                    ),
                                                    onPressed: () async {
                                                      final _endingTime =
                                                          await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay.now(),
                                                          );
                                                      if (_endingTime == null) {
                                                        return;
                                                      }
                                                      if (context.mounted) {
                                                        final _toUpdateItem =
                                                            _item.copyWith(
                                                              end_hour:
                                                                  _endingTime
                                                                      .hour,
                                                              end_min:
                                                                  _endingTime
                                                                      .minute,
                                                            );
                                                        await shellFunction(
                                                          context,
                                                          toExecute: () async {
                                                            await c.updateScheduleShift(
                                                              c.clinic!,
                                                              c.clinicSchedule!,
                                                              _toUpdateItem,
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(color: Colors.grey),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        context
                                                            .loc
                                                            .allowedNumberOfVisits,
                                                      ),
                                                      Text(' '),
                                                      Text(
                                                        ' - ${_item.visit_count} - ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: FloatingActionButton.small(
                                                    tooltip: context.loc.update,
                                                    heroTag:
                                                        '${_item.id}visit-count-picker',
                                                    child: const Icon(
                                                      Icons.numbers,
                                                    ),
                                                    onPressed: () async {
                                                      final _visitCount =
                                                          await showDialog<
                                                            int?
                                                          >(
                                                            context: context,
                                                            builder: (context) {
                                                              return VisitPerShiftDialog();
                                                            },
                                                          );
                                                      if (_visitCount == null) {
                                                        return;
                                                      }
                                                      if (context.mounted) {
                                                        final _toUpdateShift =
                                                            _item.copyWith(
                                                              visit_count:
                                                                  _visitCount,
                                                            );
                                                        await shellFunction(
                                                          context,
                                                          toExecute: () async {
                                                            await c.updateScheduleShift(
                                                              c.clinic!,
                                                              c.clinicSchedule!,
                                                              _toUpdateShift,
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(color: Colors.grey),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
