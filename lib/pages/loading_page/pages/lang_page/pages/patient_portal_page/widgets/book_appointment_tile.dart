import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/patient_portal_api.dart';
import 'package:one/core/api/sms_api.dart';
import 'package:one/core/logic/client_notification_formatter_sender.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/notifications/in_app_action.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/portal_models/portal_booking_data.dart';
import 'package:one/models/portal_models/portal_clinic.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/widgets/book_appointment_from_portal_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_portal.dart';
import 'package:one/widgets/info_dialog.dart';
import 'package:provider/provider.dart';

class BookAppointmentTile extends StatefulWidget {
  const BookAppointmentTile({
    super.key,
    required this.org_id,
    this.patient,
  });
  final String org_id;
  final Patient? patient;
  @override
  State<BookAppointmentTile> createState() => _BookAppointmentTileState();
}

class _BookAppointmentTileState extends State<BookAppointmentTile> {
  ElevatedButton buildButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        //todo: show dialog with booking info
        final _data = await showDialog<PortalBookingData?>(
          context: context,
          builder: (context) {
            return ChangeNotifierProvider.value(
              value: PxPatientPortal(
                api: PatientPortalApi(
                  org_id: widget.org_id,
                  patient_id: widget.patient?.id ?? '',
                ),
              ),
              child: BookAppointmentFromPortalDialog(
                patient: widget.patient,
              ),
            );
          },
        );
        //todo: extract info from dialog
        if (_data == null) {
          return;
        }
        //todo: add info to db
        if (context.mounted) {
          await shellFunction(
            context,
            toExecute: () async {
              await context.read<PxPatientPortal>().bookNewVisit(_data);
            },
            duration: const Duration(milliseconds: 600),
          );
        }
        if (context.mounted) {
          final _isEnglish = context.read<PxLocale>().isEnglish;
          final _clinics =
              (context.read<PxPatientPortal>().clinics
                      as ApiDataResult<List<PortalClinic>>)
                  .data;
          final _clinic = _clinics.firstWhere((c) => c.id == _data.clinic_id);
          //todo: send fcm notification to organization assistants
          ClientNotificationFormatterSender(
              organizationExpanded:
                  (context.read<PxPatientPortal>().organization!
                          as ApiDataResult<OrganizationExpanded>)
                      .data,
              isEnglish: _isEnglish,
            )
            ..formatFromInAppAction(
              action: InAppAction.portal_booking,
              account_types:
                  context.read<PxAppConstants>().constants?.accountTypes ?? [],
              patient_name: _data.patient_name,
              patient_phone: _data.patient_phone,
              visit_date: DateTime.parse(_data.preferred_date),
              clinic_name: _isEnglish ? _clinic.name_en : _clinic.name_ar,
            )
            ..send();
        }
        //todo: send sms notification to user that appointment will be confirmed
        await SmsApi(
          phone: _data.patient_phone,
          sms: _data.formatSms,
        ).sendSms().whenComplete(() async {
          if (context.mounted) {
            await showDialog(
              context: context,
              builder: (context) {
                return InfoDialog(
                  message: _data.formatSms,
                );
              },
            );
          }
        });
      },
      label: Text(context.loc.bookAppointment),
      icon: const Icon(Icons.calendar_month),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: 6,
      color: Colors.blue.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(context.loc.bookNewVisit),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(context.loc.bookAppointmentPrompt),
                  ),
                  if (!context.isMobile) ...[
                    const Spacer(),
                    buildButton(context),
                  ],
                ],
              ),
              if (context.isMobile) ...[
                buildButton(context),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
