import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_prescription_state.dart';
import 'package:provider/provider.dart';

class WidgetByKey extends StatelessWidget {
  const WidgetByKey({
    super.key,
    required this.mapKey,
    required this.visit_data,
  });
  final String mapKey;
  final VisitData visit_data;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitPrescriptionState, PxLocale>(
      builder: (context, s, l, _) {
        return switch (mapKey) {
          'patient_name' => SizedBox(
            child: Text(
              visit_data.patient.name,
              style: TextStyle(
                fontSize: s.visitPrescriptionItemsFontSize[mapKey],
              ),
            ),
          ),

          'visit_date' => SizedBox(
            child: Text(
              intl.DateFormat(
                'dd / MM / yyyy',
                l.lang,
              ).format(visit_data.visit!.visit_date),
              style: TextStyle(
                fontSize: s.visitPrescriptionItemsFontSize[mapKey],
              ),
            ),
          ),
          'visit_type' => SizedBox(
            child: Text(
              ' * ${VisitTypeEnum.visitType(
                visit_data.visit!.visit_type,
                l.isEnglish,
              )}',
              style: TextStyle(
                fontSize: s.visitPrescriptionItemsFontSize[mapKey],
              ),
            ),
          ),
          //-----//
          'visit_labs' => SizedBox(
            child: Text.rich(
              TextSpan(
                text: 'التحاليل المطلوبة\n',
                children: [
                  ...visit_data.labs.map((
                    e,
                  ) {
                    return TextSpan(
                      text:
                          ' * '
                          '${e.name_en}\n',
                      children: [
                        if (e.special_instructions.isNotEmpty)
                          TextSpan(
                            text: '(${e.special_instructions})\n',
                          ),
                      ],
                    );
                  }),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: s.visitPrescriptionItemsFontSize[mapKey],
              ),
            ),
          ),
          'visit_rads' => SizedBox(
            child: Text.rich(
              TextSpan(
                text: 'الاشاعات المطلوبة\n',
                children: [
                  ...visit_data.rads.map((
                    e,
                  ) {
                    return TextSpan(
                      text:
                          ' * '
                          '${e.name_en}\n',
                      children: [
                        if (e.special_instructions.isNotEmpty)
                          TextSpan(
                            text: '(${e.special_instructions})\n',
                          ),
                      ],
                    );
                  }),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: s.visitPrescriptionItemsFontSize[mapKey],
              ),
            ),
          ),
          'visit_procedures' => SizedBox(
            child: Text.rich(
              TextSpan(
                text: 'اجراءات الزيارة\n',
                children: [
                  ...visit_data.procedures.map(
                    (e) {
                      return TextSpan(
                        text:
                            ' * '
                            '${e.name_en}\n',
                      );
                    },
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: s.visitPrescriptionItemsFontSize[mapKey],
              ),
            ),
          ),

          'doctor_name' => SizedBox(
            child: Text.rich(
              TextSpan(
                text: '',
                children: [
                  TextSpan(
                    text: l.isEnglish
                        ? visit_data.doctor?.name_en
                        : visit_data.doctor?.name_ar,
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: s.visitPrescriptionItemsFontSize[mapKey],
              ),
            ),
          ),

          'visit_drugs' => SizedBox(
            child: Text.rich(
              TextSpan(
                text: '',
                children: [
                  ...visit_data.drugs.map((
                    e,
                  ) {
                    return TextSpan(
                      locale: const Locale(
                        'en',
                      ),
                      text: '',
                      children: [
                        TextSpan(
                          text: '\n',
                        ),
                        TextSpan(
                          text: 'Rx  ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: e.prescriptionNameEn,
                        ),
                        TextSpan(
                          text: '\n',
                        ),
                        TextSpan(
                          text: '${visit_data.drug_data[e.id]}',
                        ),
                      ],
                    );
                  }),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: s.visitPrescriptionItemsFontSize[mapKey],
              ),
            ),
          ),
          _ => const SizedBox(),
        };
      },
    );
  }
}
