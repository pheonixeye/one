import 'package:one/models/organization.dart';
import 'package:one/models/patient.dart';

class SmsFormatter {
  const SmsFormatter({
    required this.organization,
    required this.shlink,
    required this.patient,
  });

  final Organization organization;
  final String shlink;
  final Patient patient;

  String formatSms() {
    return ''' 
${organization.name_ar},
تم تسجيل بيانات باسم
${patient.name},
برجاء الحفاظ علي هذا الرابط
($shlink)
''';
  }
}
