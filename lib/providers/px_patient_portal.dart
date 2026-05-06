import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/documents/s3_documents_api.dart';
import 'package:one/core/api/patient_portal_api.dart';
import 'package:one/extensions/datetime_ext.dart';
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

  Patient? get _patientData => (_patient as ApiDataResult<Patient>).data;

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
    calculatePatientEntryNumber(null);
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

  (String d, String m, int i, String? y)? get splitMarker {
    if (_selectedScheduleUiMarker == null) return null;
    final _split = _selectedScheduleUiMarker?.split('-');
    if (_split != null && _split.isNotEmpty) {
      return (_split[0], _split[1], int.parse(_split[2]), _split[3]);
    }
    return null;
  }

  DateTime get _selectedVisitDate => DateTime(
    int.parse('${splitMarker?.$4}'),
    int.parse('${splitMarker?.$2}'),
    int.parse('${splitMarker?.$1}'),
  );

  void setSelectedScheduleUiMarker(String? value) {
    _selectedScheduleUiMarker = value;
    notifyListeners();
  }

  int? _patientEntryNumber;
  int? get patientEntryNumber => _patientEntryNumber;

  Future<void> calculatePatientEntryNumber([int? value]) async {
    if (_selectedClinic != null &&
        _selectedSchedule != null &&
        _selectedShift != null) {
      final _data =
          (_oneMonthOneClinicVisits as ApiDataResult<List<VisitExpanded>>).data;

      final _filteredVisits = _data
          .where(
            (v) =>
                v.clinic_id == _selectedClinic?.id &&
                v.visit_date.isTheSameDate(_selectedVisitDate) &&
                v.isInSameShift(_selectedSchedule!, _selectedShift!),
          )
          .toList();
      _patientEntryNumber = value ?? _filteredVisits.length + 1;
      notifyListeners();
    }
  }

  bool get bookingDataIsComplete {
    return _patient != null &&
        _selectedClinic != null &&
        _selectedSchedule != null &&
        _selectedShift != null &&
        splitMarker != null &&
        _patientEntryNumber != null;
  }

  Visit? _formulatedVisit;
  Visit? get formulatedVisit => _formulatedVisit;

  void formulateVisit() {
    _formulatedVisit = Visit(
      id: '',
      doc_id: '${_selectedClinic?.doc_id.first}',
      clinic_id: '${_selectedClinic?.id}',
      patient_id: '${_patientData?.id}',
      referral_id: '', //TODO
      patient_entry_number: _patientEntryNumber ?? 0,
      intday: _selectedSchedule?.intday ?? 0,
      s_m: _selectedShift?.start_min ?? 0,
      s_h: _selectedShift?.start_hour ?? 0,
      e_m: _selectedShift?.end_min ?? 0,
      e_h: _selectedShift?.end_hour ?? 0,
      visit_date: _selectedVisitDate,
      added_by: '${_patientData?.name}',
      comments: 'Patient Portal Booking',
      visit_status: 'Not Attended',
      visit_type: 'Consultation',
      patient_progress_status: 'Has Not Attended Yet',
    );
  }
}
