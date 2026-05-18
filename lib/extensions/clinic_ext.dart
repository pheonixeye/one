import 'package:flutter/material.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

extension BookingUrl on Clinic {
  String bookingUrlClinic(BuildContext context) {
    final _pxLocale = context.read<PxLocale>();
    final _lang = _pxLocale.lang;
    final _pxAuth = context.read<PxAuth>();
    final _org_id = _pxAuth.organization?.id;
    final _url =
        '${const String.fromEnvironment('APP_BASE_URL')}/$_lang/patients_portal?view=new&org_id=$_org_id&doc_id=${doc_id.first}';
    return _url;
  }
}
