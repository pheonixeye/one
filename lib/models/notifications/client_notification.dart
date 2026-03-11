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
    DateTime? visit_date,
    String? discount_amount,
    String? procedure_name,
    String? procedure_amount,
    String? old_visit_status,
    String? new_visit_status,
    String? old_visit_shift,
    String? new_visit_shift,
    String? old_visit_type,
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
      //TODO: formulate notification bodies
      InAppAction.add_new_visit => isEnglish ? ''' ''' : ''' ''',

      InAppAction.add_procedure_to_visit => isEnglish ? ''' ''' : ''' ''',

      InAppAction.remove_procedure_from_visit => isEnglish ? ''' ''' : ''' ''',

      InAppAction.add_discount_to_visit => isEnglish ? ''' ''' : ''' ''',

      InAppAction.remove_discount_from_visit => isEnglish ? ''' ''' : ''' ''',

      InAppAction.update_visit_status => isEnglish ? ''' ''' : ''' ''',

      InAppAction.update_visit_shift => isEnglish ? ''' ''' : ''' ''',

      InAppAction.update_visit_type => isEnglish ? ''' ''' : ''' ''',

      InAppAction.visit_is_cancled_by_patient => isEnglish ? ''' ''' : ''' ''',
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
    String message_body = switch (call.name) {
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
