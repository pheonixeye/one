import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';

class BookAppointmentTile extends StatelessWidget {
  const BookAppointmentTile({super.key});

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
                    ElevatedButton.icon(
                      onPressed: () async {
                        //TODO:
                      },
                      label: Text(context.loc.bookAppointment),
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ],
              ),
              if (context.isMobile) ...[
                ElevatedButton.icon(
                  onPressed: () async {
                    //TODO:
                  },
                  label: Text(context.loc.bookAppointment),
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
