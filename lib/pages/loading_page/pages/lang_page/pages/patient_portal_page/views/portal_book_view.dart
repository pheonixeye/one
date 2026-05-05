import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/clinic_schedule_shift_ext.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/weekdays.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/scan_patient_qr_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_portal.dart';
import 'package:provider/provider.dart';

const Map<int, Icon> _stepIcons = {
  0: Icon(
    Icons.person_add,
    size: 12,
  ),
  1: Icon(
    Icons.info,
    size: 12,
  ),
  2: Icon(
    Icons.calendar_month,
    size: 12,
  ),
  3: Icon(
    Icons.check,
    size: 12,
  ),
  4: Icon(
    Icons.done_all,
    size: 12,
  ),
};

class PortalBookView extends StatefulWidget {
  const PortalBookView({super.key});

  @override
  State<PortalBookView> createState() => _PortalBookViewState();
}

class _PortalBookViewState extends State<PortalBookView> {
  //TODO: handle portal query accordingly
  late final _patientInfoFormKey = GlobalKey<FormState>();
  late final ScrollController _controller;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  int _step = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPatientPortal, PxLocale>(
      builder: (context, p, l, _) {
        return Column(
          children: [
            Expanded(
              child: Stepper(
                elevation: 6,
                controlsBuilder: (context, details) {
                  return const SizedBox();
                },
                controller: _controller,
                type: context.isMobile
                    ? StepperType.vertical
                    : StepperType.horizontal,
                currentStep: _step,
                onStepTapped: (value) {
                  setState(() {
                    _step = value;
                  });
                },
                stepIconBuilder: (stepIndex, stepState) {
                  return _stepIcons[stepIndex];
                },
                steps: [
                  Step(
                    isActive: _step == 0,
                    title: Text(context.loc.enterBookingDetails),
                    content: Form(
                      key: _patientInfoFormKey,
                      child: Card.outlined(
                        elevation: 6,
                        child: Column(
                          spacing: 4,
                          children: [
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(context.loc.name),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'رباعي بالعربي',
                                  ),
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return context.loc.enterPatientName;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(context.loc.mobileNumber),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '01##-####-###',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return context.loc.enterPatientPhone;
                                    }
                                    if (value.length != 11) {
                                      return context.loc.enterValidPatientPhone;
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  keyboardType: TextInputType.phone,
                                  maxLength: 11,
                                ),
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 4,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final _patient_id =
                                        await showDialog<String?>(
                                          context: context,
                                          builder: (context) {
                                            return ScanPatientQrDialog();
                                          },
                                        );
                                    if (_patient_id == null) {
                                      return;
                                    }
                                    //todo: get patient data
                                    if (context.mounted) {
                                      await shellFunction(
                                        context,
                                        toExecute: () async {
                                          await p.fetchPatientById(_patient_id);
                                          if (context.mounted) {
                                            final _patient =
                                                (p.patient
                                                        as ApiDataResult<
                                                          Patient
                                                        >)
                                                    .data;
                                            setState(() {
                                              _nameController.text =
                                                  _patient.name;
                                              _phoneController.text =
                                                  _patient.phone;
                                              _step = 1;
                                            });
                                          }
                                        },
                                        duration: const Duration(
                                          milliseconds: 260,
                                        ),
                                      );
                                    }
                                  },
                                  label: Text(context.loc.scanQrCode),
                                  icon: const Icon(Icons.qr_code_2),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_patientInfoFormKey.currentState!
                                        .validate()) {
                                      if (context.mounted) {
                                        await shellFunction(
                                          context,
                                          toExecute: () async {
                                            final _patient = Patient(
                                              id: '',
                                              name: _nameController.text,
                                              phone: _phoneController.text,
                                              dob: '',
                                              email: '',
                                            );
                                            await p.addNewPatient(_patient);
                                            setState(() {
                                              _step = 1;
                                            });
                                          },
                                          duration: const Duration(
                                            milliseconds: 260,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  label: Text(context.loc.next),
                                  icon: const Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Step(
                    isActive: _step == 1,
                    title: Text.rich(
                      TextSpan(
                        text: context.loc.pickClinic,
                        children: [
                          if (p.selectedClinic != null) ...[
                            TextSpan(text: ' - '),
                            TextSpan(
                              text:
                                  '(${l.isEnglish ? p.selectedClinic?.name_en : p.selectedClinic?.name_ar})',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    content: Card.outlined(
                      elevation: 6,
                      child: Builder(
                        builder: (context) {
                          while (p.oneDoctorClinics == null) {
                            return const SizedBox(
                              height: 8,
                              child: LinearProgressIndicator(),
                            );
                          }
                          final _clinics =
                              (p.oneDoctorClinics
                                      as ApiDataResult<List<Clinic>>)
                                  .data;
                          return RadioGroup<Clinic>(
                            groupValue: p.selectedClinic,
                            onChanged: (value) {
                              p.selectClinic(value);
                              if (p.selectedClinic != null) {
                                setState(() {
                                  _step = 2;
                                });
                              }
                            },
                            child: Column(
                              spacing: 4,
                              children: [
                                ..._clinics.map((clinic) {
                                  return RadioListTile(
                                    titleAlignment: ListTileTitleAlignment.top,
                                    title: Text(
                                      l.isEnglish
                                          ? clinic.name_en
                                          : clinic.name_ar,
                                    ),
                                    subtitle: const Divider(),
                                    value: clinic,
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Step(
                    isActive: _step == 2 && p.selectedClinic != null,
                    title: Text(context.loc.pickVisitDate),
                    content: Card.outlined(
                      elevation: 6,
                      child: Column(
                        spacing: 4,
                        children: [
                          if (p.selectedClinic != null)
                            SizedBox(
                              height:
                                  (p.clinicAvailableDates != null &&
                                      p.clinicAvailableDates!.isEmpty)
                                  ? 0
                                  : 80,
                              child: ListView.builder(
                                itemCount: p.clinicAvailableDates?.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final _date = p.clinicAvailableDates![index];
                                  final _weekday = Weekdays.getWeekday(
                                    _date!.weekday,
                                  );
                                  final _itemValue =
                                      '${_date.day}-${_date.month}-${_weekday.id}';
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FilterChip.elevated(
                                      selectedColor: Colors.amber.shade400,
                                      showCheckmark: false,
                                      label: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 4,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${_date.day} / ${_date.month}'
                                                .toArabicNumber(context),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            l.isEnglish
                                                ? _weekday.en
                                                : _weekday.ar,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      selected:
                                          p.selectedScheduleUiMarker ==
                                          _itemValue,
                                      onSelected: (value) {
                                        p.setSelectedScheduleUiMarker(
                                          _itemValue,
                                        );
                                        final _sch = p
                                            .selectedClinic
                                            ?.clinic_schedule
                                            .firstWhere(
                                              (e) => e.intday == _date.weekday,
                                            );
                                        p.selectClinicSchedule(_sch);
                                        p.selectScheduleShift(null);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (p.clinicAvailableDates != null &&
                              p.clinicAvailableDates!.isEmpty)
                            SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(context.loc.noAvailableDates),
                              ),
                            ),
                          if (p.selectedSchedule != null) ...[
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  context.loc.pickClinicScheduleShift,
                                ),
                              ),
                              subtitle: RadioGroup<ScheduleShift>(
                                groupValue: p.selectedShift,
                                onChanged: (value) {
                                  p.selectScheduleShift(value);
                                  //find patient entry number
                                },
                                child: Column(
                                  children: [
                                    ...p.selectedSchedule!.shifts.map((shift) {
                                      return RadioListTile(
                                        title: Text(
                                          shift.formattedFromTo(context),
                                        ),
                                        value: shift,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Step(
                    isActive: _step == 3,

                    title: Text('Confirm Booking Details'),
                    content: Card.outlined(
                      elevation: 6,
                      child: Text('booking confirmation step'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
