import 'package:one/extensions/number_translator.dart';
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PreviousVisitViewCard extends StatelessWidget {
  const PreviousVisitViewCard({
    super.key,
    required this.item,
    required this.index,
    this.showIndexNumber = true,
    this.showPatientName = false,
  });
  final VisitExpanded item;
  final int index;
  final bool showIndexNumber;
  final bool showPatientName;
  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Column(
                spacing: 8,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      SmBtn(
                        child: showIndexNumber
                            ? Text('${index + 1}'.toArabicNumber(context))
                            : SizedBox(),
                      ),
                      Text(
                        DateFormat(
                          'dd - MM - yyyy',
                          l.lang,
                        ).format(item.visit_date),
                      ),
                    ],
                  ),
                  if (showPatientName)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 50.0),
                      child: Row(
                        spacing: 8,
                        children: [
                          Text(
                            l.isEnglish ? 'Patient Name:' : 'اسم المريض:',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Text(item.patient.name),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 50.0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          l.isEnglish ? 'Doctor:' : 'دكتور:',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          l.isEnglish
                              ? item.doctor.name_en
                              : item.doctor.name_ar,
                        ),
                        Text(
                          l.isEnglish ? 'CLinic:' : 'عيادة:',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          l.isEnglish
                              ? item.clinic.name_en
                              : item.clinic.name_ar,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsetsDirectional.only(start: 50.0),
                child: Row(
                  spacing: 8,
                  children: [
                    Text(
                      l.isEnglish ? 'Visit:' : 'نوع الزيارة:',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    Text(
                      VisitTypeEnum.visitType(
                        item.visit_type,
                        l.isEnglish,
                      ),
                    ),
                    Text(
                      l.isEnglish ? 'Attendance:' : 'الحضور:',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    if (item.visit_status ==
                        context.read<PxAppConstants>().attended.name_en)
                      const Icon(Icons.check, color: Colors.green)
                    else
                      const Icon(Icons.close, color: Colors.red),
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
