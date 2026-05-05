import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/documents/s3_documents_api.dart';
import 'package:one/core/api/patient_portal_api.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/clinic/clinic_schedule.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/models/patients_portal/portal_query.dart';
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
      switch (api.query.view) {
        case PortalView.patient_view:
          await _fetchClinics();
          await _fetchPatient();
        case PortalView.book_view:
          await _fetchOneDoctorClinics();
        case _:
          return;
      }
    }
  }

  static ApiResult<OrganizationExpanded>? _organization;
  ApiResult<OrganizationExpanded>? get organization => _organization;

  Future<void> _fetchOrganization() async {
    _organization = await api.fetchOrganization();
    if (_organization != null && _organization is! ApiErrorResult) {
      final _org = (_organization as ApiDataResult<OrganizationExpanded>).data;
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

  static ApiResult<List<Clinic>>? _allClinics;
  ApiResult<List<Clinic>>? get allClinics => _allClinics;

  static ApiResult<List<Clinic>>? _oneDoctorClinics;
  ApiResult<List<Clinic>>? get oneDoctorClinics => _oneDoctorClinics;

  Future<void> _fetchClinics() async {
    _allClinics = await api.fetchClinics();
    notifyListeners();
  }

  Future<void> _fetchOneDoctorClinics() async {
    _oneDoctorClinics = api.query.doc_id == null || api.query.doc_id!.isEmpty
        ? await api.fetchClinics()
        : await api.fetchDoctorClinics();
    notifyListeners();
  }

  static ApiResult<Patient>? _patient;
  ApiResult<Patient>? get patient => _patient;

  Future<void> _fetchPatient() async {
    _patient = await api.fetchPatient();
    notifyListeners();
  }

  Future<void> fetchPatientById(String patient_id) async {
    _patient = await api.fetchPatientById(patient_id);
    notifyListeners();
  }

  Future<void> addNewPatient(Patient patient) async {
    _patient = await api.addNewPatientOrFetchPatientIfAlreadyExists(patient);
    // print((_patient as ApiDataResult<Patient>).data.toJson());
    notifyListeners();
  }

  Future<void> retryFetchPatient() async => await _fetchPatient();

  ApiResult<List<VisitExpanded>>? _onePatientVisits;
  ApiResult<List<VisitExpanded>>? get onePatientVisits => _onePatientVisits;

  ApiResult<List<VisitExpanded>>? _oneMonthOneClinicVisits;
  ApiResult<List<VisitExpanded>>? get oneMonthOneClinicVisits =>
      _oneMonthOneClinicVisits;

  Future<void> fetchOnePatientVisits() async {
    _onePatientVisits = await api.fetchVisitsOfOnePatient();
    notifyListeners();
  }

  Future<void> fetchOneMonthOneClinicVisits({
    required int month,
    required int year,
    required String clinic_id,
  }) async {
    _oneMonthOneClinicVisits = await api.fetctVisitsOfOneMonthOneClinic(
      month: month,
      year: year,
      clinic_id: clinic_id,
    );
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

  Future<void> bookNewVisit(Visit visit) async {
    await api.addNewVisit(visit);
  }

  Clinic? _selectedClinic;
  Clinic? get selectedClinic => _selectedClinic;

  void selectClinic(Clinic? value) {
    _selectedClinic = value;
    notifyListeners();
    setClinicAvailabeDates();
    selectClinicSchedule(null);
    setSelectedScheduleUiMarker(null);
    selectScheduleShift(null);
  }

  ClinicSchedule? _selectedSchedule;
  ClinicSchedule? get selectedSchedule => _selectedSchedule;

  void selectClinicSchedule(ClinicSchedule? value) {
    _selectedSchedule = value;
    notifyListeners();
  }

  ScheduleShift? _selectedShift;
  ScheduleShift? get selectedShift => _selectedShift;

  void selectScheduleShift(ScheduleShift? value) {
    _selectedShift = value;
    notifyListeners();
  }

  final _now = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  int get todayIntday => _now.weekday;

  late final List<DateTime> _daysOfThisYear = List.generate(
    365,
    (i) {
      return DateTime(_now.year, 1, i + 1);
    },
  );

  late final List<DateTime> _daysOfThisYearStartingToday = _daysOfThisYear
      .where((e) => e.isAfter(_now))
      .toList();

  List<DateTime?>? _clinicAvailableDates;
  List<DateTime?>? get clinicAvailableDates => _clinicAvailableDates;

  void setClinicAvailabeDates() {
    _clinicAvailableDates = _daysOfThisYearStartingToday.map((e) {
      final _clinicAvailableWeekdays = _selectedClinic?.clinic_schedule.map(
        (c) => c.intday,
      );
      if (_clinicAvailableWeekdays != null &&
          _clinicAvailableWeekdays.contains(e.weekday)) {
        return e;
      } else {
        return null;
      }
    }).toList();
    _clinicAvailableDates?.removeWhere((e) => e == null);
    notifyListeners();
  }

  String? _selectedScheduleUiMarker;
  String? get selectedScheduleUiMarker => _selectedScheduleUiMarker;

  void setSelectedScheduleUiMarker(String? value) {
    _selectedScheduleUiMarker = value;
    notifyListeners();
  }
}
