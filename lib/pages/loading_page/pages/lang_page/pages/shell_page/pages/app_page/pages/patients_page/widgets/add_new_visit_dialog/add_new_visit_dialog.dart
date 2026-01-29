import 'package:one/extensions/datetime_ext.dart';
import 'package:one/models/doctor.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/widgets/clinic_picker.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/widgets/clinic_schedule_picker.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/widgets/comments_picker.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/widgets/doctor_picker.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/widgets/progress_status_picker.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/widgets/schedule_shift_picker.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/widgets/visit_date_picker.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/widgets/visit_status_picker.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/widgets/visit_type_picker.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/patient.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class AddNewVisitDialog extends StatelessWidget {
  const AddNewVisitDialog({super.key, required this.patient});
  final Patient patient;
  @override
  Widget build(BuildContext context) {
    return Consumer6<
      PxAppConstants,
      PxDoctor,
      PxClinics,
      PxVisits,
      PxAddNewVisitDialog,
      PxLocale
    >(
      builder: (context, a, d, c, v, s, l, _) {
        while (a.constants == null ||
            c.result == null ||
            v.visits == null ||
            (context.read<PxAuth>().isUserNotDoctor && d.allDoctors == null)) {
          return CentralLoading();
        }
        while (c.result is ApiErrorResult || v.visits is ApiErrorResult) {
          return CentralError(
            code: (v.visits as ApiErrorResult).errorCode,
            toExecute: () async {
              await c.retry();
              await v.retry();
            },
          );
        }
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.addNewVisit,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '(${patient.name})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: context.isMobile ? s.width : s.width / 2,
            height: context.isMobile ? s.height - 150 : s.height,
            child: Form(
              key: s.formKey,
              child: ListView(
                cacheExtent: 3000,
                children: [
                  ClinicPicker(
                    clinics: (c.result as ApiDataResult<List<Clinic>>).data,
                  ),

                  if (context.read<PxAuth>().isUserNotDoctor)
                    DoctorPicker(
                      doctors: (d.allDoctors as List<Doctor>),
                    ),

                  if (s.clinic != null) const ClinicSchedulePicker(),

                  const VisitDatePicker(),

                  const ScheduleShiftPicker(),

                  const VisitTypePicker(),

                  const VisitStatusPicker(),

                  const ProgressStatusPicker(),

                  const CommentsPicker(),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                if (s.formKey.currentState!.validate()) {
                  s.toggleLoading();
                  final _dateClinicVisits = await v.preCreateVisitRequest(
                    s.visitDate!,
                    s.clinic!.id,
                  );
                  final _nextEntryNumber = _dateClinicVisits.length + 1;
                  s.toggleLoading();
                  final _patientHasDuplicateVisit = _dateClinicVisits.any(
                    (v) =>
                        v.clinic_id == s.clinic!.id &&
                        v.visit_date.isTheSameDate(s.visitDate!) &&
                        v.patient_id == patient.id,
                  );

                  if (_patientHasDuplicateVisit && context.mounted) {
                    final _toProceed = await showDialog<bool?>(
                      context: context,
                      builder: (context) {
                        return PromptDialog(
                          message: context.loc.duplicateVisitPrompt,
                        );
                      },
                    );
                    if (_toProceed == null || _toProceed == false) {
                      return;
                    }
                  }

                  if (context.mounted) {
                    final _visitDto = Visit(
                      id: '',
                      clinic_id: s.clinic!.id,
                      patient_id: patient.id,
                      added_by: context.read<PxAuth>().user!.name,
                      doc_id: context.read<PxAuth>().isUserNotDoctor
                          ? s.doctor!.id
                          : context.read<PxAuth>().doc_id,
                      visit_date: s.visitDate!,
                      patient_entry_number: _nextEntryNumber,
                      visit_status: s.visitStatus!.name_en,
                      visit_type: s.visitType!.name_en,
                      patient_progress_status: s.patientProgressStatus!.name_en,
                      comments: s.commentsController.text,
                      intday: s.clinicSchedule!.intday,
                      s_h: s.scheduleShift!.start_hour,
                      s_m: s.scheduleShift!.start_min,
                      e_h: s.scheduleShift!.end_hour,
                      e_m: s.scheduleShift!.end_min,
                    );
                    Navigator.pop(context, _visitDto);
                  }
                }
              },
              label: Text(context.loc.confirm),
              icon: Icon(Icons.check, color: Colors.green.shade100),
            ),
            if (s.isLoading) CupertinoActivityIndicator(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: Text(context.loc.cancel),
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
