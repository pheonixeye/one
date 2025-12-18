import 'dart:typed_data';

// import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/clinics_api.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/clinic/clinic_schedule.dart';
import 'package:one/models/clinic/prescription_details.dart';
import 'package:one/models/clinic/schedule_shift.dart';
// import 'package:provider/provider.dart';

class PxClinics extends ChangeNotifier {
  final ClinicsApi api;
  // final BuildContext context;

  PxClinics({
    required this.api,
    // required this.context,
  }) {
    _fetchDoctorClinics();
  }

  static ApiResult<List<Clinic>>? _result;
  ApiResult<List<Clinic>>? get result => _result;

  Future<void> _fetchDoctorClinics(
    // {int retries = 3}
  ) async {
    //HACK: why did i use this snippet ??

    // while (
    //     !context.mounted || context.read<PxAppConstants>().constants == null) {
    //   await Future.delayed(const Duration(seconds: 1));
    //   await _fetchDoctorClinics(retries: retries - 1);
    //   if (_result != null) {
    //     break;
    //   }
    //   if (retries <= 0) {
    //     break;
    //   }
    // }
    if (PxAuth.isUserNotDoctor) {
      _result = await api.fetchAllClinics();
      notifyListeners();
    } else {
      _result = await api.fetchDoctorClinics();
      notifyListeners();
    }
  }

  Future<void> retry() async => await _fetchDoctorClinics();

  Future<void> createNewClinic(Clinic clinic) async {
    await api.createNewClinic(clinic);
    await _fetchDoctorClinics();
  }

  Future<void> updateClinicInfo(Clinic clinic) async {
    await api.updateClinicInfo(clinic);
    await _fetchDoctorClinics();
  }

  Future<void> deleteClinic(Clinic clinic) async {
    await api.deleteClinic(clinic);
    await _fetchDoctorClinics();
  }

  Future<void> toggleClinicActivation(Clinic clinic) async {
    await api.toggleClinicActivation(clinic);
    await _fetchDoctorClinics();
  }

  static Clinic? _clinic;
  Clinic? get clinic => _clinic;

  void selectClinic(Clinic? value) {
    _clinic = value == null
        ? null
        : (_result as ApiDataResult<List<Clinic>>).data.firstWhereOrNull(
            (e) => e.id == value.id,
          );
    notifyListeners();
  }

  Future<void> updatePrescriptionFile({
    required Uint8List file_bytes,
    required String filename,
  }) async {
    if (_clinic == null) {
      return;
    }
    await api.addPrescriptionImageFileToClinic(
      _clinic!,
      file_bytes: file_bytes,
      filename: filename,
    );
    await _fetchDoctorClinics();
    selectClinic(_clinic);
  }

  Future<void> deletePrescriptionFile() async {
    if (_clinic == null) {
      return;
    }
    await api.deletePrescriptionFile(_clinic!);
    await _fetchDoctorClinics();
    selectClinic(
      (_result as ApiDataResult<List<Clinic>>).data.firstWhere(
        (e) => e.id == _clinic?.id,
      ),
    );
  }

  Future<void> updatePrescriptionDetails(PrescriptionDetails details) async {
    if (_clinic == null) {
      return;
    }
    await api.updatePrescriptionDetails(_clinic!, details);
    await _fetchDoctorClinics();
    selectClinic(_clinic);
  }

  Future<void> addClinicSchedule(Clinic clinic, ClinicSchedule schedule) async {
    await api.addClinicSchedule(clinic, schedule);
    await _fetchDoctorClinics();
    selectClinic(_clinic);
  }

  Future<void> removeClinicSchedule(
    Clinic clinic,
    ClinicSchedule schedule,
  ) async {
    await api.removeClinicSchedule(clinic, schedule);
    await _fetchDoctorClinics();
    selectClinic(_clinic);
  }

  Future<void> updateClinicSchedule(
    Clinic clinic,
    ClinicSchedule schedule,
  ) async {
    await api.updateClinicSchedule(clinic, schedule);
    await _fetchDoctorClinics();
    selectClinic(_clinic);
  }

  Future<void> addScheduleShift(
    Clinic clinic,
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    await api.addScheduleShift(clinic, schedule, shift);
    await _fetchDoctorClinics();
    selectClinic(_clinic);
    setCliniSchedule(_clinicSchedule);
  }

  Future<void> removeScheduleShift(
    Clinic clinic,
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    await api.removeScheduleShift(clinic, schedule, shift);
    await _fetchDoctorClinics();
    selectClinic(_clinic);
    setCliniSchedule(_clinicSchedule);
  }

  Future<void> updateScheduleShift(
    Clinic clinic,
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    await api.updateScheduleShift(clinic, schedule, shift);
    await _fetchDoctorClinics();
    selectClinic(_clinic);
    setCliniSchedule(_clinicSchedule);
  }

  ClinicSchedule? _clinicSchedule;
  ClinicSchedule? get clinicSchedule => _clinicSchedule;

  void setCliniSchedule(ClinicSchedule? _sch) {
    if (_clinic != null) {
      _clinicSchedule = _clinic!.clinic_schedule.firstWhereOrNull(
        (e) => e.id == _sch?.id,
      );
      notifyListeners();
    }
  }

  Future<void> addOrRemoveDoctorFromClinic(String doc_id) async {
    if (_clinic == null) {
      return;
    }
    await api.addOrRemoveDoctorFromClinic(clinic!, doc_id);
    await _fetchDoctorClinics();
  }
}
