import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:one/models/notifications/clinic_call.dart';
import 'package:one/models/notifications/in_app_action.dart';

class ClientNotification extends Equatable {
  final String client_token;
  final String message_title;
  final String message_body;
  final String server_url;

  const ClientNotification({
    required this.client_token,
    required this.message_title,
    required this.message_body,
    required this.server_url,
  });

  ClientNotification copyWith({
    String? client_token,
    String? message_title,
    String? message_body,
    String? server_url,
  }) {
    return ClientNotification(
      client_token: client_token ?? this.client_token,
      message_title: message_title ?? this.message_title,
      message_body: message_body ?? this.message_body,
      server_url: server_url ?? this.server_url,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'client_token': client_token,
      'message_title': message_title,
      'message_body': message_body,
      'server_url': server_url,
    };
  }

  factory ClientNotification.fromJson(Map<String, dynamic> map) {
    return ClientNotification(
      client_token: map['client_token'] as String,
      message_title: map['message_title'] as String,
      message_body: map['message_body'] as String,
      server_url: map['server_url'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    client_token,
    message_title,
    message_body,
    server_url,
  ];

  factory ClientNotification.fromInAppAction({
    required bool isEnglish,
    required String client_token,
    required String server_url,
    required InAppAction inAppAction,
    String? patient_name,
    String? patient_phone,
    String? clinic_name,
    String? doctor_name,
    DateTime? visit_date,
    String? discount_amount,
    String? procedure_name,
    String? procedure_amount,
    String? visit_status,
    String? new_visit_status,
    String? visit_shift,
    String? new_visit_shift,
    String? visit_type,
    String? new_visit_type,
  }) {
    final message_title = switch (inAppAction) {
      _ => isEnglish ? inAppAction.en_title : inAppAction.ar_title,
    };

    final _dateString = visit_date == null
        ? ''
        : DateFormat(
            'dd / MM / yyyy',
            isEnglish ? 'en' : 'ar',
          ).format(visit_date);

    final message_body = switch (inAppAction) {
      // todo: formulate notification bodies
      InAppAction.add_new_visit =>
        isEnglish
            ? '''
Patient Name : $patient_name,
Visit Date : $_dateString,
Clinic : $clinic_name,
Visit Type : $visit_type
 '''
            : '''
اسم المريض :  $patient_name,
تاريخ الزيارة :  $_dateString,
العيادة : $clinic_name,
نوع الزيارة : $visit_type
 ''',

      InAppAction.add_procedure_to_visit =>
        isEnglish
            ? '''
Doctor $doctor_name Has Added A New Procedure To $patient_name Visit,
Procedure : $procedure_name,
Fees : $procedure_amount EGP,
Kindly Note If The Procedure Fees Is Collected From The Patient.
 '''
            : '''
قام الدكتور / $doctor_name باضافة اجراء طبي لزيارة المريض $patient_name,
الاجراء : $procedure_name,
المبلغ : $procedure_amount,
برجاء التأكد من تحصيل المبلغ من المريض.
 ''',

      InAppAction.remove_procedure_from_visit =>
        isEnglish
            ? '''
Doctor $doctor_name Has Removed A Procedure From $patient_name Visit,
Procedure : $procedure_name,
Fees : $procedure_amount EGP,
Kindly Note If The Procedure Fees Is Returned To The Patient.
 '''
            : '''
قام الدكتور / $doctor_name باازالة اجراء طبي من زيارة المريض $patient_name,
الاجراء : $procedure_name,
المبلغ : $procedure_amount,
برجاء التأكد من رد المبلغ للمريض.
 ''',

      InAppAction.add_discount_to_visit =>
        isEnglish
            ? '''
A Discount Of $discount_amount EGP Was Applied To $patient_name Visit.
Kindly Check If It Was Financially Processed.
 '''
            : '''
تم اضافة خصم بقيمة $discount_amount جنيه لزيارة المريض $patient_name.
برجاء التأكد من التحصيل / الرد للمبلغ.
 ''',

      InAppAction.remove_discount_from_visit =>
        isEnglish
            ? '''
A Discount Of $discount_amount EGP Was Removed From $patient_name Visit.
Kindly Check If It Was Financially Processed.
 '''
            : '''
تم ازالة خصم بقيمة $discount_amount جنيه من زيارة المريض $patient_name.
برجاء التأكد من التحصيل / الرد للمبلغ.
 ''',

      InAppAction.update_visit_status =>
        isEnglish
            ? '''
Patient $patient_name Visit Status Was Updated From $visit_status To $new_visit_status.
 '''
            : '''
تم تعديل حالة زيارة المريض $patient_name من الحالة $visit_status الي الحالة $new_visit_status.
 ''',

      InAppAction.update_visit_shift =>
        isEnglish
            ? '''
Patient $patient_name Visit Shift Was Changed From $visit_shift To Be At $new_visit_shift.
Kindly Check If The Patient Is Notified.
 '''
            : '''
تم تغيير موعد زيارة المريض $patient_name من الموعد $visit_shift لتصبح $new_visit_shift.
برجاء التاكد من تنبيه المريض بتغيير الموعد.
 ''',

      InAppAction.update_visit_type =>
        isEnglish
            ? '''
Patient $patient_name Visit Type Was Updated From $visit_type To $new_visit_type.
Kindly Check If It Was Financially Processed.
 '''
            : '''
تم تغيير نوع زيارة المرض $patient_name من $visit_status لتصبح $new_visit_status.
برجاء التأكد منصحة المعاملات المادية من تحصيل او رد الفارق.
 ''',

      InAppAction.visit_is_cancled_by_patient =>
        isEnglish
            ? '''
Patient $patient_name Has Canceled The Scheduled Visit on $_dateString.
 '''
            : '''
قام المريض $patient_name بالغاء الزيارة المجدولة بتاريخ $_dateString.
 ''',
      InAppAction.portal_booking =>
        isEnglish
            ? '''
Patient Name : $patient_name,
Patient Phone : $patient_phone,
Visit Date : $_dateString,
Clinic : $clinic_name,
 '''
            : '''
اسم المريض :  $patient_name,
التليفون :  $patient_phone,
تاريخ الزيارة :  $_dateString,
العيادة : $clinic_name,
 ''',
    };

    return ClientNotification(
      client_token: client_token,
      message_title: message_title,
      message_body: message_body,
      server_url: server_url,
    );
  }

  factory ClientNotification.fromClinicCall({
    required bool isEnglish,
    required ClinicCall call,
    required String client_token,
    required String server_url,
    String? doctor_name,
    String? fees_amount,
    String? patient_name,
  }) {
    String message_body = switch (call.type) {
      CallEnum.pause_clinic =>
        isEnglish
            ? '''
Doctor $doctor_name Would Like To Pause The Clinic.
'''
            : '''
يرغب دكتور $doctor_name في ايقاف العيادة.
''',
      //todo
      CallEnum.resume_clinic =>
        isEnglish
            ? '''
Doctor $doctor_name Would Like To Resume The Clinic.
'''
            : '''
يرغب دكتور $doctor_name في استمرار العيادة.
''',
      CallEnum.next_patient =>
        isEnglish
            ? '''
Doctor $doctor_name Would Like To Have The Next Patient.
'''
            : '''
يرغب دكتور $doctor_name في دخول المريض التالي.
''',
      CallEnum.assistant_attend =>
        isEnglish
            ? '''
Doctor $doctor_name Would Like The Assistant To Attend.
'''
            : '''
يرغب دكتور $doctor_name في حضور المساعد.
''',
      CallEnum.collect_fees =>
        isEnglish
            ? '''
Doctor $doctor_name Would Like To Collect $fees_amount L.E. From Mr/Mrs $patient_name.
'''
            : '''
يرغب دكتور $doctor_name في تحصيل مبلغ $fees_amount من المريض $patient_name.
''',
      CallEnum.return_fees =>
        isEnglish
            ? '''
Doctor $doctor_name Would Like To Return $fees_amount L.E. To Mr/Mrs $patient_name.
'''
            : '''
يرغب دكتور $doctor_name في اعادة مبلغ $fees_amount للمريض $patient_name.
''',
      //assistant notifications
      CallEnum.next_patient_ready =>
        isEnglish
            ? '''
The Next Patient Is Ready.
'''
            : '''
المريض التالي جاهز للدخول.
''',
      CallEnum.next_patient_irritated =>
        isEnglish
            ? '''
The Next Patient Is Irritated.
'''
            : '''
المريض التالي مستاء.
''',
    };
    return ClientNotification(
      client_token: client_token,
      message_title: isEnglish ? call.en : call.ar,
      message_body: message_body,
      server_url: server_url,
    );
  }
}
