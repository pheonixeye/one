import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class PortalBookingData extends Equatable {
  final String patient_name;
  final String patient_phone;
  final String preferred_date;
  final String clinic_id;
  final String? message;

  const PortalBookingData({
    required this.patient_name,
    required this.patient_phone,
    required this.preferred_date,
    required this.clinic_id,
    this.message,
  });

  PortalBookingData copyWith({
    String? patient_name,
    String? patient_phone,
    String? preferred_date,
    String? clinic_id,
    String? message,
  }) {
    return PortalBookingData(
      patient_name: patient_name ?? this.patient_name,
      patient_phone: patient_phone ?? this.patient_phone,
      preferred_date: preferred_date ?? this.preferred_date,
      clinic_id: clinic_id ?? this.clinic_id,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'patient_name': patient_name,
      'patient_phone': patient_phone,
      'preferred_date': preferred_date,
      'clinic_id': clinic_id,
      'message': message,
    };
  }

  factory PortalBookingData.fromJson(Map<String, dynamic> map) {
    return PortalBookingData(
      patient_name: map['patient_name'] as String,
      patient_phone: map['patient_phone'] as String,
      preferred_date: map['preferred_date'] as String,
      clinic_id: map['clinic_id'] as String,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    patient_name,
    patient_phone,
    preferred_date,
    clinic_id,
    message,
  ];

  String get formatSms =>
      '''
تم استلام طلب الحجز باسم 
$patient_name
بتاريخ
${DateFormat('dd/MM/yyyy', 'ar').format(DateTime.parse(preferred_date))}
سيتم التواصل عن طريق العيادة لتاكيد تفاصيل الحجز
 ''';
}
