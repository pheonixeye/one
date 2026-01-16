import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/clinic_schedule_shift_ext.dart';
import 'package:one/extensions/datetime_ext.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MonthlyVisitsCalendarDialog extends StatefulWidget {
  const MonthlyVisitsCalendarDialog({super.key});

  @override
  State<MonthlyVisitsCalendarDialog> createState() =>
      _MonthlyVisitsCalendarDialogState();
}

class _MonthlyVisitsCalendarDialogState
    extends State<MonthlyVisitsCalendarDialog> {
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: DateFormat(
        'MM - yyyy',
        context.read<PxLocale>().lang,
      ).format(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxClinics, PxVisits, PxLocale>(
      builder: (context, c, v, l, _) {
        while (c.result == null || v.monthlyVisits == null) {
          return const CentralLoading();
        }
        while (v.monthlyVisits is ApiErrorResult) {
          return CentralError(
            code: (v.monthlyVisits as ApiErrorResult).errorCode,
            toExecute: v.fetchVisitsOfOneMonth,
          );
        }

        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.visitsCalender,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text:
                            '(${DateFormat('MM - yyyy', l.lang).format(v.nowMonth)})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              children: [
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Text(context.loc.selectMonth),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: _dateController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SmBtn(
                          tooltip: context.loc.pickStartingDate,
                          onPressed: () async {
                            //TODO: change implementation to pick month and year only
                            final _date = await showDatePicker(
                              context: context,
                              initialDatePickerMode: DatePickerMode.year,
                              firstDate: DateTime.now().copyWith(
                                year: DateTime.now().year - 10,
                              ),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (_date != null) {
                              _dateController.text = DateFormat(
                                'MM - yyyy',
                                l.lang,
                              ).format(_date);
                              if (context.mounted) {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await v.fetchVisitsOfOneMonth(
                                      month: _date.month,
                                      year: _date.year,
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: const Icon(Icons.calendar_month_rounded),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (v.monthlyVisits != null &&
                          (v.monthlyVisits!
                                  as ApiDataResult<List<VisitExpanded>>)
                              .data
                              .isEmpty) {
                        return CentralNoItems(
                          message:
                              context.loc.noVisitsFoundForSelectedDateRange,
                        );
                      }
                      final _data =
                          (v.monthlyVisits
                                  as ApiDataResult<List<VisitExpanded>>)
                              .data;
                      final _clinics =
                          (c.result as ApiDataResult<List<Clinic>>).data;

                      return ListView.separated(
                        itemCount: v.nowMonth.daysPerMonth,
                        separatorBuilder: (context, index) => const Divider(),
                        cacheExtent: 3000,
                        itemBuilder: (context, index) {
                          final _calculatedDate = DateTime(
                            v.nowMonth.year,
                            v.nowMonth.month,
                            index + 1,
                          );
                          final _intday = _calculatedDate.weekday;
                          return Card.outlined(
                            elevation: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                titleAlignment: ListTileTitleAlignment.top,
                                leading: SmBtn(
                                  key: UniqueKey(),
                                  onPressed: null,
                                  child: Text(
                                    '${index + 1}'.toArabicNumber(context),
                                  ),
                                ),
                                title: Text.rich(
                                  TextSpan(
                                    text: DateFormat.EEEE(l.lang).format(
                                      v.nowMonth.add(Duration(days: index)),
                                    ),
                                    children: [
                                      TextSpan(text: '\n'),
                                      TextSpan(
                                        text:
                                            DateFormat(
                                              'dd / MM / yyyy',
                                              l.lang,
                                            ).format(
                                              v.nowMonth.add(
                                                Duration(days: index),
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 0,
                                    children: [
                                      ..._clinics.map((clinic) {
                                        return ListTile(
                                          titleAlignment: ListTileTitleAlignment
                                              .titleHeight,
                                          leading: Text('•'),
                                          title: Card.outlined(
                                            elevation: 2,
                                            color: Colors.blue.shade50,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                2.0,
                                              ),
                                              child: Text(
                                                l.isEnglish
                                                    ? clinic.name_en
                                                    : clinic.name_ar,
                                              ),
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 0,
                                            children: [
                                              ...clinic.clinic_schedule.map((
                                                sch,
                                              ) {
                                                if (sch.intday == _intday) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    spacing: 0,
                                                    children: [
                                                      ...sch.shifts.map((
                                                        shift,
                                                      ) {
                                                        return ListTile(
                                                          titleAlignment:
                                                              ListTileTitleAlignment
                                                                  .titleHeight,
                                                          leading: Text('•'),
                                                          title: Card.outlined(
                                                            elevation: 2,
                                                            color: Colors
                                                                .amber
                                                                .shade50,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    2.0,
                                                                  ),
                                                              child: Text(
                                                                shift
                                                                    .formattedFromTo(
                                                                      context,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            spacing: 0,
                                                            children: [
                                                              ..._data.map((
                                                                visit,
                                                              ) {
                                                                if (visit
                                                                        .isInSameShift(
                                                                          sch,
                                                                          shift,
                                                                        ) &&
                                                                    _calculatedDate
                                                                        .isTheSameDate(
                                                                          visit
                                                                              .visit_date,
                                                                        ) &&
                                                                    visit.clinic_id ==
                                                                        clinic
                                                                            .id) {
                                                                  return ListTile(
                                                                    titleAlignment:
                                                                        ListTileTitleAlignment
                                                                            .titleHeight,
                                                                    leading:
                                                                        Text(
                                                                          '•',
                                                                        ),
                                                                    title: Text(
                                                                      visit
                                                                          .patient
                                                                          .name,
                                                                    ),
                                                                    subtitle: Text(
                                                                      VisitTypeEnum.visitType(
                                                                        visit
                                                                            .visit_type,
                                                                        l.isEnglish,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                return SizedBox();
                                                              }),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              }),
                                            ],
                                          ),
                                        );
                                      }),
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
    );
  }
}
