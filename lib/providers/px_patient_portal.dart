import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/patient_portal_api.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/patient.dart';

class PxPatientPortal extends ChangeNotifier {
  final PatientPortalApi api;

  PxPatientPortal({required this.api}) {
    _init();
  }

  Future<void> _init() async {
    await _fetchOrganization();
    // await _fetchPatient();
  }

  ApiResult<Organization>? _organization;
  ApiResult<Organization>? get organization => _organization;

  Future<void> _fetchOrganization() async {
    _organization = await api.fetchOrganization();
    if (_organization != null && _organization is! ApiErrorResult) {
      final _org = (_organization as ApiDataResult<Organization>).data;
      PocketbaseHelper.initializedPortalPb(_org.pb_endpoint);
    }
    notifyListeners();
  }

  Future<void> retryFetchOrganization() async => await _fetchOrganization();

  ApiResult<Patient>? _patient;
  ApiResult<Patient>? get patient => _patient;

  Future<void> _fetchPatient() async {
    _patient = await api.fetchPatient();
    notifyListeners();
  }

  Future<void> retryFetchPatient() async => await _fetchPatient();
}

enum PatientPortalPageStates {
  got_organization,
  got_organization_patient,
  got_organization_no_patient_scan,
  got_organization_patient_visits,
}
