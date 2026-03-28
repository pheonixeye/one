import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/portal_models/portal_booking_data.dart';
import 'package:one/models/portal_models/portal_clinic.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_portal.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class BookAppointmentFromPortalDialog extends StatefulWidget {
  const BookAppointmentFromPortalDialog({
    super.key,
    required this.patient,
  });
  final Patient? patient;
  @override
  State<BookAppointmentFromPortalDialog> createState() =>
      _BookAppointmentFromPortalDialogState();
}

class _BookAppointmentFromPortalDialogState
    extends State<BookAppointmentFromPortalDialog> {
  late final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dateController;
  late final TextEditingController _messageController;

  String? _formattedDate;
  PortalClinic? _clinic;

  late final TODAY = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient?.name ?? '');
    _phoneController = TextEditingController(text: widget.patient?.phone ?? '');
    _dateController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.bookAppointment,
                    style: TextStyle(fontWeight: FontWeight.bold),
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
          scrollable: true,
          content: SizedBox(
            width: context.isMobile
                ? MediaQuery.widthOf(context)
                : MediaQuery.widthOf(context) / 2,
            height: MediaQuery.heightOf(context) / 2,
            child: Card.outlined(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.loc.name),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: context.loc.enterName,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.loc.enterName;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.loc.phone),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: context.loc.enterPhone,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.loc.enterPhone;
                              }
                              if (value.length != 11) {
                                return context.loc.enterValidPhoneNumber;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.loc.clinic),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Consumer<PxPatientPortal>(
                            builder: (context, p, _) {
                              while (p.clinics == null) {
                                return const SizedBox(
                                  height: 10,
                                  child: LinearProgressIndicator(),
                                );
                              }
                              final _clinics =
                                  (p.clinics
                                          as ApiDataResult<List<PortalClinic>>)
                                      .data;
                              return DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<PortalClinic>(
                                  alignment: Alignment.center,
                                  items: [
                                    ..._clinics.map((clinic) {
                                      return DropdownMenuItem(
                                        value: clinic,
                                        alignment: Alignment.center,
                                        child: Text.rich(
                                          TextSpan(
                                            text: l.isEnglish
                                                ? clinic.name_en
                                                : clinic.name_ar,
                                            children: [
                                              TextSpan(text: '\n'),
                                              TextSpan(
                                                text: l.isEnglish
                                                    ? clinic.doc_name_en
                                                    : clinic.doc_name_ar,
                                              ),
                                              TextSpan(
                                                text: ' - ',
                                              ),
                                              TextSpan(
                                                text: l.isEnglish
                                                    ? clinic.spec_en
                                                    : clinic.spec_ar,
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _clinic = value;
                                    });
                                  },
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: context.loc.pickClinic,
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return context.loc.pickClinic;
                                    }
                                    return null;
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.loc.preferredDate),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enabled: false,
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: context.loc.selectPreferredDate,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return context.loc.selectPreferredDate;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              SmBtn(
                                onPressed: () async {
                                  final _date = await showDatePicker(
                                    context: context,
                                    firstDate: TODAY,
                                    lastDate: TODAY.add(
                                      const Duration(days: 365),
                                    ),
                                  );
                                  if (_date == null) {
                                    return;
                                  }
                                  setState(() {
                                    _dateController.text = DateFormat(
                                      'dd - MM - yyyy',
                                      l.lang,
                                    ).format(_date);
                                    _formattedDate = DateTime(
                                      _date.year,
                                      _date.month,
                                      _date.day,
                                    ).toIso8601String();
                                  });
                                },
                                child: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.loc.message),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: context.loc.enterMessage,
                            ),
                            minLines: 3,
                            maxLines: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate() &&
                    _formattedDate != null &&
                    _clinic != null) {
                  final _data = PortalBookingData(
                    patient_name: _nameController.text,
                    patient_phone: _phoneController.text,
                    preferred_date: _formattedDate!,
                    clinic_id: _clinic!.id,
                    message: _messageController.text,
                  );
                  Navigator.pop(context, _data);
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
