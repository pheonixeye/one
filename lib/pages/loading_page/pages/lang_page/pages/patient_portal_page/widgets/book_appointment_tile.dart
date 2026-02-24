import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';

class BookAppointmentTile extends StatefulWidget {
  const BookAppointmentTile({super.key});

  @override
  State<BookAppointmentTile> createState() => _BookAppointmentTileState();
}

class _BookAppointmentTileState extends State<BookAppointmentTile> {
  ElevatedButton get _buildButton {
    return ElevatedButton.icon(
      onPressed: () async {
        //TODO: show dialog with booking info
        //TODO: extract info from dialog
        //TODO: add info to db
        //TODO: send fcm notification to organization assistants
        //TODO: send sms notification to user that appointment will be confirmed
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
                    _buildButton,
                  ],
                ],
              ),
              if (context.isMobile) ...[
                _buildButton,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
