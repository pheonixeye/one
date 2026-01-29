import 'package:flutter/material.dart';
import 'package:one/models/app_constants/patient_progress_status.dart';
import 'package:one/models/app_constants/visit_status.dart';
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/clinic/clinic_schedule.dart';
import 'package:one/models/clinic/schedule_shift.dart';
import 'package:one/models/doctor.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:provider/provider.dart';

class PxAddNewVisitDialog extends ChangeNotifier {
  final BuildContext context;

  PxAddNewVisitDialog({required this.context});

  final selectedShape = RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.circular(12),
    side: BorderSide(),
  );
  final unselectedShape = RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.circular(12),
  );

  final selectedColor = Colors.amber.shade50;
  final unSelectedColor = Colors.white;

  RoundedRectangleBorder tileBorder(bool isSelected) {
    return isSelected ? selectedShape : unselectedShape;
  }

  Widget validationErrorWidget<T>(FormFieldState<T> field) {
    if (!field.validate()) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 8.0),
          child: Text(
            field.errorText ?? '',
            style: TextStyle(fontSize: 12, color: Colors.red),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  final formKey = GlobalKey<FormState>();

  late final TextEditingController _visitDateController =
      TextEditingController();
  TextEditingController get visitDateController => _visitDateController;

  late final TextEditingController _commentsController =
      TextEditingController();
  TextEditingController get commentsController => _commentsController;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double get width => MediaQuery.sizeOf(context).width;
  double get height => MediaQuery.sizeOf(context).height;

  Clinic? _clinic;
  Clinic? get clinic => _clinic;

  ClinicSchedule? _clinicSchedule;
  ClinicSchedule? get clinicSchedule => _clinicSchedule;

  ScheduleShift? _scheduleShift;
  ScheduleShift? get scheduleShift => _scheduleShift;

  DateTime? _visitDate;
  DateTime? get visitDate => _visitDate;

  Doctor? _doctor;
  Doctor? get doctor => _doctor;

  late VisitType? _visitType = context.read<PxAppConstants>().consultation;
  VisitType? get visitType => _visitType;

  late VisitStatus? _visitStatus = context.read<PxAppConstants>().notAttended;
  VisitStatus? get visitStatus => _visitStatus;

  late PatientProgressStatus? _patientProgressStatus = context
      .read<PxAppConstants>()
      .has_not_attended_yet;
  PatientProgressStatus? get patientProgressStatus => _patientProgressStatus;

  void selectClinic(Clinic? value) {
    _clinic = value;
    notifyListeners();
  }

  void selectClinicSchedule(ClinicSchedule? value) {
    _clinicSchedule = value;
    notifyListeners();
  }

  void selectVisitDate(DateTime? value) {
    _visitDate = value;
    notifyListeners();
  }

  void selectDoctor(Doctor? value) {
    _doctor = value;
    notifyListeners();
  }

  void selectScheduleShift(ScheduleShift? value) {
    _scheduleShift = value;
    notifyListeners();
  }

  void selectVisitType(VisitType? value) {
    _visitType = value;
    notifyListeners();
  }

  void selectVisitStatus(VisitStatus? value) {
    _visitStatus = value;
    notifyListeners();
  }

  void selectProgressStatus(PatientProgressStatus? value) {
    _patientProgressStatus = value;
    notifyListeners();
  }

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  @override
  void dispose() {
    _visitDateController.dispose();
    _commentsController.dispose();
    super.dispose();
  }
}
