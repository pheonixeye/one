import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/patient.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class PatientTile extends StatelessWidget {
  const PatientTile({super.key, required this.patient});
  final Patient patient;
  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return Card.outlined(
          elevation: 6,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 8,
                children: [
                  SmBtn(
                    child: const Icon(Icons.person),
                  ),
                  Text(patient.name),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 50.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: context.loc.phone,
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(text: patient.phone),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: context.loc.dateOfBirth,
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: DateFormat(
                              'dd-MM-yyyy',
                              l.lang,
                            ).format(DateTime.parse(patient.dob)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
