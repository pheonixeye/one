import 'package:flutter/material.dart';
import 'package:one/core/api/specialities_api.dart';
import 'package:one/functions/dprint.dart';
import 'package:one/models/speciality.dart';

class PxSpec extends ChangeNotifier {
  PxSpec() {
    _init();
  }

  Future<void> _init() async {
    if (_specialities == null) {
      _specialities = await SpecialitiesApi.fetchSpecialities();
      notifyListeners();
      dprint('PxSpec._init()');
    }
  }

  static List<Speciality>? _specialities;
  List<Speciality>? get specialities => _specialities;

  Speciality? _speciality;
  Speciality? get speciality => _speciality;

  void selectSpeciality(Speciality value) {
    _speciality = value;
    notifyListeners();
  }
}
