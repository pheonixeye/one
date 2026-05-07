import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/patients_portal/portal_query.dart';
import 'package:one/router/router.dart';

class BookAppointmentTile extends StatefulWidget {
  const BookAppointmentTile({
    super.key,
    required this.query,
    this.patient,
  });
  final PortalQuery query;
  final Patient? patient;
  @override
  State<BookAppointmentTile> createState() => _BookAppointmentTileState();
}

class _BookAppointmentTileState extends State<BookAppointmentTile> {
  ElevatedButton buildButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        GoRouter.of(context).goNamed(
          AppRouter.patients_portal,
          pathParameters: defaultPathParameters(context),
          queryParameters: {
            'view': 'new',
            'org_id': widget.query.org_id,
            'patient_id': widget.query.patient_id,
            'doc_id': widget.query.doc_id,
          },
        );
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
