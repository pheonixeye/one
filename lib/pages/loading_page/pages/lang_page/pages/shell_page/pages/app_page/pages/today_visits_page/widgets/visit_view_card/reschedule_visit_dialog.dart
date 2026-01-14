import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/models/shift.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/previous_visit_view_card.dart';
import 'package:one/providers/px_visits_per_clinic_shift.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RescheduleVisitDialog extends StatefulWidget {
  const RescheduleVisitDialog({super.key, required this.visit});
  final Visit visit;

  @override
  State<RescheduleVisitDialog> createState() => _RescheduleVisitDialogState();
}

class _RescheduleVisitDialogState extends State<RescheduleVisitDialog> {
  final formKey = GlobalKey<FormState>();

  ScheduleShift? _shift;

  @override
  void initState() {
    super.initState();
    final _sch = widget.visit.clinic.clinic_schedule.firstWhere(
      (sch) => sch.intday == widget.visit.intday,
    );
    setState(() {
      _shift = _sch.shifts.firstWhere(
        (shift) => widget.visit.isInSameShift(_sch, shift),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxVisitsPerClinicShift>(
      builder: (context, v, _) {
        while (v.visitsPerShift == null) {
          return const CentralLoading();
        }
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text(context.loc.rescheduleVisitShift)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton.outlined(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          scrollable: true,
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: context.isMobile
                ? MediaQuery.sizeOf(context).width
                : MediaQuery.sizeOf(context).width / 2,
            child: Form(
              key: formKey,
              child: FormField(
                builder: (field) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    PreviousVisitViewCard(
                      item: widget.visit,
                      index: 0,
                      showIndexNumber: false,
                      showPatientName: true,
                    ),
                    const Divider(),
                    RadioGroup(
                      groupValue: _shift,
                      onChanged: (value) {
                        setState(() {
                          _shift = value;
                        });
                      },
                      child: Column(
                        children: [
                          ...widget.visit.clinic.clinic_schedule
                              .firstWhere(
                                (sch) => sch.intday == widget.visit.intday,
                              )
                              .shifts
                              .map((shift) {
                                final _isSelected = shift == _shift;
                                return Card.outlined(
                                  elevation: _isSelected ? 0 : 6,
                                  color: _isSelected
                                      ? Colors.amber.shade50
                                      : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      12,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RadioListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(12),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(shift.formattedFromTo(context)),
                                          const Spacer(),
                                          Builder(
                                            builder: (context) {
                                              final _sh =
                                                  Shift.fromScheduleShift(
                                                    shift,
                                                  );
                                              final _visitsPerShift =
                                                  v.visitsPerShift?[_sh];
                                              while (_visitsPerShift == null) {
                                                return CircularProgressIndicator();
                                              }
                                              return Text.rich(
                                                TextSpan(
                                                  text: '$_visitsPerShift'
                                                      .toArabicNumber(context),
                                                  children: [
                                                    TextSpan(text: ' / '),
                                                    TextSpan(
                                                      text:
                                                          '(${shift.visit_count})'
                                                              .toArabicNumber(
                                                                context,
                                                              ),
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                      value: shift,
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),

                    Text(
                      field.errorText ?? '',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ),
                validator: (value) {
                  if (_shift == null) {
                    return context.loc.pickClinicScheduleShift;
                  }
                  return null;
                },
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, _shift);
                }
              },
              label: Text(context.loc.confirm),
              icon: Icon(Icons.check, color: Colors.green.shade100),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: Text(context.loc.cancel),
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
