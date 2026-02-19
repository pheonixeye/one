import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/documents/s3_documents_api.dart';
import 'package:one/core/api/patient_portal_api.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/models/visits/visit.dart';
import 'package:s3_dart_lite/s3_dart_lite.dart';

class PxPatientPortal extends ChangeNotifier {
  final PatientPortalApi api;

  PxPatientPortal({required this.api}) {
    _init();
  }

  static S3DocumentsApi? _s3documentsApi;

  Future<void> _init() async {
    await _fetchOrganization();
    if (_organization != null && _organization is! ApiErrorResult) {
      await _fetchPatient();
    }
  }

  static ApiResult<Organization>? _organization;
  ApiResult<Organization>? get organization => _organization;

  Future<void> _fetchOrganization() async {
    _organization = await api.fetchOrganization();
    if (_organization != null && _organization is! ApiErrorResult) {
      final _org = (_organization as ApiDataResult<Organization>).data;
      PocketbaseHelper.initializedPortalPb(_org.pb_endpoint);
      _s3documentsApi = S3DocumentsApi(
        clientOptions: ClientOptions(
          endPoint: _org.s3_endpoint,
          secretKey: _org.s3_secret,
          accessKey: _org.s3_key,
          bucket: _org.s3_bucket,
          region: '',
        ),
      );
    }
    notifyListeners();
  }

  Future<void> retryFetchOrganization() async => await _fetchOrganization();

  static ApiResult<Patient>? _patient;
  ApiResult<Patient>? get patient => _patient;

  Future<void> _fetchPatient() async {
    _patient = await api.fetchPatient();
    notifyListeners();
  }

  Future<void> retryFetchPatient() async => await _fetchPatient();

  ApiResult<List<VisitExpanded>>? _visits;
  ApiResult<List<VisitExpanded>>? get visits => _visits;

  Future<void> fetchVisits() async {
    _visits = await api.fetchVisitsOfOnePatient();
    notifyListeners();
  }

  ApiResult<List<PatientDocumentWithDocumentType>>? _visitDocuments;
  ApiResult<List<PatientDocumentWithDocumentType>>? get visitDocuments =>
      _visitDocuments;

  Future<void> fetchVisitDocuments(String visit_id) async {
    _visitDocuments = await api.fetchVisitDocuments(visit_id: visit_id);
    notifyListeners();
  }

  static Future<Uint8List?> getOneDocument({
    required String objectName,
  }) async {
    try {
      return await _s3documentsApi?.getDocument(
        objectName: objectName,
      );
    } catch (e) {
      rethrow;
    }
  }
}
