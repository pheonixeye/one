import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CallEnum {
  pause_clinic,
  resume_clinic,
  next_patient,
  assistant_attend,
  collect_fees,
  return_fees,
  next_patient_ready,
  next_patient_irritated,
}

class ClinicCall extends Equatable {
  final CallEnum type;
  final String en;
  final String ar;
  final IconData iconData;

  const ClinicCall({
    required this.type,
    required this.en,
    required this.ar,
    required this.iconData,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    type,
    en,
    ar,
    iconData,
  ];
}

class DoctorClinicCall extends ClinicCall {
  const DoctorClinicCall({
    required super.type,
    required super.en,
    required super.ar,
    required super.iconData,
  });

  static List<ClinicCall> calls = [
    DoctorClinicCall(
      type: CallEnum.pause_clinic,
      en: 'Pause Clinic',
      ar: 'ايقاف العيادة',
      iconData: Icons.pause_circle,
    ),
    DoctorClinicCall(
      type: CallEnum.resume_clinic,
      en: 'Resume Clinic',
      ar: 'استمرار العيادة',
      iconData: Icons.play_circle,
    ),
    DoctorClinicCall(
      type: CallEnum.next_patient,
      en: 'Next Patient',
      ar: 'المريض التالي',
      iconData: Icons.next_plan,
    ),
    DoctorClinicCall(
      type: CallEnum.assistant_attend,
      en: 'Assistant Attend',
      ar: 'حضور المساعد',
      iconData: Icons.person_add_alt,
    ),
    DoctorClinicCall(
      type: CallEnum.collect_fees,
      en: 'Collect Fees',
      ar: 'تحصيل رسوم',
      iconData: Icons.monetization_on,
    ),
    DoctorClinicCall(
      type: CallEnum.return_fees,
      en: 'Return Fees',
      ar: 'رد رسوم',
      iconData: Icons.money_off_csred,
    ),
  ];
}

class AssistantClinicCall extends ClinicCall {
  const AssistantClinicCall({
    required super.type,
    required super.en,
    required super.ar,
    required super.iconData,
  });

  static List<ClinicCall> calls = [
    AssistantClinicCall(
      type: CallEnum.next_patient_ready,
      en: 'Next Patient Ready',
      ar: 'المريض التالي جاهز',
      iconData: Icons.pause_circle,
    ),
    AssistantClinicCall(
      type: CallEnum.next_patient_irritated,
      en: 'Next Patient Irritated',
      ar: 'المريض التالي مستاء',
      iconData: Icons.personal_injury,
    ),
  ];
}
