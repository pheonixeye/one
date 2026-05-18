import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/models/speciality.dart';
import 'package:http/http.dart' as http;
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

extension Imageurl on Speciality {
  String get imageUrl =>
      '${PocketbaseHelper.pbBase.baseURL}/api/files/specialities/$id/$image';
}

extension PrescriptionFileUrl on Clinic {
  String prescriptionFileUrl() =>
      '${PocketbaseHelper.pbData.baseURL}/api/files/clinics/$id/$prescription_file';

  Future<Uint8List> prescImageBytes() async {
    final _response = await http.get(Uri.parse(prescriptionFileUrl()));
    return _response.bodyBytes;
  }
}

extension PatientDocumentUrl on PatientDocument {
  String patientDocumentUrl() =>
      '${PocketbaseHelper.pbData.baseURL}/api/files/patient__documents/$id/$document_url';
}

extension AppBookingUrl on OrganizationExpanded {
  String bookingUrl(BuildContext context) {
    final _pxLocale = context.read<PxLocale>();
    final _lang = _pxLocale.lang;
    final _url =
        '${const String.fromEnvironment('APP_BASE_URL')}/$_lang/patients_portal?view=new&org_id=$id';
    return _url;
  }
}
