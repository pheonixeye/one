import 'package:one/core/api/fcm_notifications_api.dart';
import 'package:one/models/app_constants/account_type.dart';
import 'package:one/models/notifications/client_notification.dart';
import 'package:one/models/notifications/clinic_call.dart';
import 'package:one/models/notifications/in_app_action.dart';
import 'package:one/models/organization.dart';

class ClientNotificationFormatterSender {
  final FcmNotificationsApi api;
  final OrganizationExpanded organizationExpanded;
  final bool isEnglish;

  ClientNotificationFormatterSender({
    this.api = const FcmNotificationsApi(),
    required this.organizationExpanded,
    required this.isEnglish,
  });

  final List<ClientNotification> _clientNotifications = [];

  void formatFromClinicCall({
    required ClinicCall call,
    required String client_token,
    String? doctor_name,
    String? fees_amount,
    String? patient_name,
  }) {
    _clientNotifications.add(
      ClientNotification.fromClinicCall(
        isEnglish: isEnglish,
        call: call,
        client_token: client_token,
        server_url: organizationExpanded.pb_endpoint,
        doctor_name: doctor_name,
        fees_amount: fees_amount,
        patient_name: patient_name,
      ),
    );
  }

  void formatFromInAppAction({
    required InAppAction action,
    required List<AccountType> account_types,
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
    final _doc_account_type_id = account_types
        .firstWhere((a) => a.name_en == 'Doctor')
        .id;
    final _assistant_account_type_id = account_types
        .firstWhere((a) => a.name_en == 'Assistant')
        .id;
    final _tokens = switch (action.toNotify) {
      'Doctor' =>
        organizationExpanded.orgUsers
            .where((e) => e.account_type_id == _doc_account_type_id)
            .map((e) => e.fcm_token)
            .toList(),
      'Assistant' =>
        organizationExpanded.orgUsers
            .where((e) => e.account_type_id == _assistant_account_type_id)
            .map((e) => e.fcm_token)
            .toList(),
      _ => organizationExpanded.orgUsers.map((e) => e.fcm_token).toList(),
    };

    for (final _token in _tokens) {
      if (_token != null) {
        _clientNotifications.add(
          ClientNotification.fromInAppAction(
            isEnglish: isEnglish,
            client_token: _token,
            server_url: organizationExpanded.pb_endpoint,
            inAppAction: action,
            patient_name: patient_name,
            patient_phone: patient_phone,
            clinic_name: clinic_name,
            doctor_name: doctor_name,
            visit_date: visit_date,
            discount_amount: discount_amount,
            procedure_name: procedure_name,
            procedure_amount: procedure_amount,
            visit_status: visit_status,
            new_visit_status: new_visit_status,
            visit_shift: visit_shift,
            new_visit_shift: new_visit_shift,
            visit_type: visit_type,
            new_visit_type: new_visit_type,
          ),
        );
      }
    }
  }

  Future<void> send() async {
    for (final _n in _clientNotifications) {
      await api.sendFcmNotification(_n);
    }
  }
}
