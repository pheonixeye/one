import 'package:one/models/user/user.dart';
import 'package:one/providers/px_auth.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/doctor_api.dart';
import 'package:one/models/doctor.dart';
import 'package:provider/provider.dart';

//TODO: is this needed ??
class PxDoctor extends ChangeNotifier {
  final DoctorApi api;
  final BuildContext context;

  PxDoctor({
    required this.api,
    required this.context,
  }) {
    _init();
  }

  static Doctor? _doctor;
  Doctor? get doctor => _doctor;

  static User? _docAuth;
  User? get docAuth => _docAuth;

  static List<Doctor>? _allDoctors;
  List<Doctor>? get allDoctors => _allDoctors;

  static List<User>? _allDoctorsAuth;
  List<User>? get allDoctorsAuth => _allDoctorsAuth;

  Future<void> _init() async {
    if (context.read<PxAuth>().isUserNotDoctor) {
      _allDoctors = await api.fetchAllDoctors();
      _allDoctorsAuth = await api.fetchAllDoctorsAuthAccounts();
      notifyListeners();
    } else {
      _allDoctors = await api.fetchAllDoctors();
      _allDoctorsAuth = await api.fetchAllDoctorsAuthAccounts();
      _doctor = await api.fetchDoctorProfile();
      _docAuth = await api.fetchDoctorAuthUser();
      notifyListeners();
    }
  }

  Future<void> retry() async => await _init();

  Future<void> toogleAccountActivation(String user_id, bool is_active) async {
    await api.toogleAccountActivation(user_id, is_active);
    await _init();
  }
}
