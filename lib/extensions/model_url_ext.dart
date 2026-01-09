import 'dart:typed_data';

import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/models/speciality.dart';
import 'package:http/http.dart' as http;

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
      '${PocketbaseHelper.pbData.baseURL}/api/files/patient__documents/$id/$document';
}
