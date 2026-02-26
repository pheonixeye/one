import 'package:flutter/material.dart';

enum DoctorClinicCall {
  pause_clinic(
    en: 'Pause Clinic',
    ar: 'ايقاف العيادة',
    iconData: Icons.pause_circle,
  ),
  resume_clinic(
    en: 'Resume Clinic',
    ar: 'استمرار العيادة',
    iconData: Icons.play_circle,
  ),
  next_patient(
    en: 'Next Patient',
    ar: 'المريض التالي',
    iconData: Icons.next_plan,
  ),
  assistant_attend(
    en: 'Assistant Attend',
    ar: 'حضور المساعد',
    iconData: Icons.person_add_alt,
  ),
  visit_type_change(
    en: 'Visit Type Change',
    ar: 'تغيير نوع الزيارة',
    iconData: Icons.type_specimen,
  ),
  collect_fees(
    en: 'Collect Fees',
    ar: 'تحصيل رسوم',
    iconData: Icons.monetization_on,
  ),
  return_fees(
    en: 'Return Fees',
    ar: 'رد رسوم',
    iconData: Icons.money_off_csred,
  );

  final String en;
  final String ar;
  final IconData iconData;

  const DoctorClinicCall({
    required this.en,
    required this.ar,
    required this.iconData,
  });
}
