import 'package:intl/intl.dart';
import 'package:one/core/api/patient_previous_visits_api.dart';
import 'package:one/core/api/s3_patient_documents_api.dart';
import 'package:one/core/logic/client_notification_formatter_sender.dart';
import 'package:one/extensions/datetime_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/notifications/in_app_action.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/image_source_and_document_type_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/detailed_previous_patient_visits_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/patient_documents_view_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_previous_visits.dart';
import 'package:one/providers/px_s3_patient_documents.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/router/router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:provider/provider.dart';

class VisitDetailsPageInfoHeader extends StatelessWidget {
  const VisitDetailsPageInfoHeader({
    super.key,
    required this.patient,
    required this.title,
    required this.iconData,
  });
  final Patient patient;
  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitData, PxLocale>(
      builder: (context, v, l, _) {
        while (v.result == null) {
          return LinearProgressIndicator();
        }
        final _data = (v.result as ApiDataResult<VisitData>).data;
        final _visitDate = _data.visit?.visit_date;
        final _isVisitOfToday =
            _visitDate != null &&
            DateTime.now().unTimed.isTheSameDate(_visitDate);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(child: Icon(iconData)),
            title: ChangeNotifierProvider(
              create: (context) => PxPatientPreviousVisits(
                api: PatientPreviousVisitsApi(
                  patient_id: patient.id,
                ),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Consumer<PxPatientPreviousVisits>(
                      builder: (context, prv, _) {
                        final _data =
                            (prv.data as ApiDataResult<List<VisitExpanded>>?)
                                ?.data;
                        return Text.rich(
                          TextSpan(
                            text: patient.name,
                            children: [
                              if (prv.data == null)
                                TextSpan(text: '')
                              else if (prv.data is ApiErrorResult)
                                TextSpan(text: ' - (${context.loc.error})')
                              else if (_data != null && _data.isEmpty)
                                TextSpan(
                                  text: ' - (0)'.toArabicNumber(context),
                                )
                              else
                                TextSpan(
                                  text: ' - (${_data?.length})'.toArabicNumber(
                                    context,
                                  ),
                                ),
                              if (!_isVisitOfToday) ...[
                                TextSpan(text: '\n'),
                                TextSpan(
                                  text: '(${context.loc.previousVisit})',
                                ),
                                TextSpan(text: ' - '),
                                TextSpan(
                                  text:
                                      '(${DateFormat('dd - MM - yyyy', l.lang).format(_visitDate!)})',
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Text(title),
            trailing: ThemedPopupmenuBtn<void>(
              tooltip: context.loc.patientActions,
              icon: const Icon(Icons.settings),
              borderRadius: BorderRadius.circular(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Row(
                      spacing: 8,
                      children: [
                        const Icon(
                          FontAwesomeIcons.personWalkingArrowRight,
                        ),
                        Text(context.loc.previousPatientVisits),
                      ],
                    ),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return ChangeNotifierProvider(
                            create: (context) => PxPatientPreviousVisits(
                              api: PatientPreviousVisitsApi(
                                patient_id: patient.id,
                              ),
                            ),
                            child: DetailedPreviousPatientVisitsDialog(),
                          );
                        },
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: Row(
                      spacing: 8,
                      children: [
                        const Icon(Icons.document_scanner),
                        Text(context.loc.patientDocuments),
                      ],
                    ),
                    onTap: () async {
                      //todo: show previous patient Documents
                      await showDialog<void>(
                        context: context,
                        builder: (context) {
                          return ChangeNotifierProvider(
                            key: ValueKey(patient.id),
                            create: (context) => PxS3PatientDocuments(
                              api: S3PatientDocumentApi(
                                patient_id: patient.id,
                              ),
                              context: context,
                              state: S3PatientDocumentsPxState
                                  .documents_one_patient,
                            ),
                            child: PatientDocumentsViewDialog(
                              patient: patient,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: Row(
                      spacing: 8,
                      children: [
                        const Icon(FontAwesomeIcons.prescription),
                        Text(context.loc.visitPrescription),
                      ],
                    ),
                    onTap: () {
                      //todo: go to prescription page
                      GoRouter.of(context).goNamed(
                        AppRouter.visit_prescription,
                        pathParameters: defaultPathParameters(context)
                          ..addAll({'visit_id': _data.visit_id}),
                      );
                    },
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      final _picker = ImagePicker();

                      final _imgSrcDocType =
                          await showDialog<ImageSourceAndDocumentType?>(
                            context: context,
                            builder: (context) {
                              return ImageSourceAndDocumentTypeDialog();
                            },
                          );

                      if (_imgSrcDocType == null) {
                        return;
                      }

                      final _image = await _picker.pickImage(
                        source: _imgSrcDocType.imageSource,
                      );
                      if (_image == null) {
                        return;
                      }

                      final _filename = _image.name;

                      final _file_bytes = _image.openRead();

                      final _document = PatientDocument(
                        id: '',
                        patient_id: _data.patient.id,
                        related_visit_id: _data.visit_id,
                        related_visit_data_id: _data.id,
                        document_type_id: _imgSrcDocType.document_type.id,
                        document_url: '',
                        created: DateTime.now().toUtc(),
                      );

                      if (context.mounted) {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await context
                                .read<PxS3PatientDocuments>()
                                .addPatientDocument(
                                  document: _document,
                                  payload: _file_bytes,
                                  objectName:
                                      '${patient.id}/${_imgSrcDocType.document_type.name_en}/$_filename',
                                );
                          },
                        );
                      }
                    },
                    child: Row(
                      spacing: 8,
                      children: [
                        const Icon(Icons.upload_file),
                        Text(context.loc.attachDocument),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    child: Card(
                      color: Colors.amber.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 8,
                          children: [
                            const Icon(Icons.exit_to_app),
                            Text(context.loc.completeVisit),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      final _pxVisits = context.read<PxVisits>();
                      try {
                        final _visit =
                            (_pxVisits.visits
                                    as ApiDataResult<List<VisitExpanded>>)
                                .data
                                .firstWhere((e) => e.id == _data.visit_id);
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await _pxVisits.updateVisit(
                              visit: _visit,
                              key: 'patient_progress_status',
                              value: 'Done Consultation',
                            );
                          },
                          duration: const Duration(milliseconds: 300),
                        );
                        if (context.mounted) {
                          ClientNotificationFormatterSender(
                              organizationExpanded: context
                                  .read<PxAuth>()
                                  .organization!,
                              isEnglish: context.read<PxLocale>().isEnglish,
                            )
                            ..formatFromInAppAction(
                              action: InAppAction.doctor_finished_consultation,
                              account_types:
                                  context
                                      .read<PxAppConstants>()
                                      .constants
                                      ?.accountTypes ??
                                  [],
                              clinic_name: l.isEnglish
                                  ? _visit.clinic.name_en
                                  : _visit.clinic.name_ar,
                              patient_name: _visit.patient.name,
                              doctor_name: l.isEnglish
                                  ? _visit.doctor.name_en
                                  : _visit.doctor.name_ar,
                            )
                            ..send();
                        }
                        if (context.mounted) {
                          GoRouter.of(context).goNamed(
                            AppRouter.app,
                            pathParameters: defaultPathParameters(context),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showIsnackbar(context.loc.errorEndingVisit);
                        }
                      }
                    },
                  ),
                ];
              },
            ),
          ),
        );
      },
    );
  }
}
