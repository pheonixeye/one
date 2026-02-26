import 'package:flutter/material.dart';

enum AssistantClinicCalls {
  next_patient_ready(
    en: 'Next Patient Ready',
    ar: 'المريض التالي جاهز',
    iconData: Icons.pause_circle,
  ),
  visit_type_change(
    en: 'Visit Type Change',
    ar: 'تغيير نوع الزيارة',
    iconData: Icons.type_specimen,
  ),
  next_patient_irritated(
    en: 'Next Patient Irritated',
    ar: 'المريض التالي مستاء',
    iconData: Icons.personal_injury,
  );

  final String en;
  final String ar;
  final IconData iconData;

  const AssistantClinicCalls({
    required this.en,
    required this.ar,
    required this.iconData,
  });
}
