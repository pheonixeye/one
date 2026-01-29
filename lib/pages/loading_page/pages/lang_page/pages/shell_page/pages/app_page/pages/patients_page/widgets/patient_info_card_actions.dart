import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one/core/api/forms_api.dart';
import 'package:one/core/api/patient_forms_api.dart';
import 'package:one/core/api/patient_previous_visits_api.dart';
import 'package:one/core/api/s3_patient_documents_api.dart';
import 'package:one/extensions/datetime_ext.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/add_new_visit_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/patient_forms_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/patient_id_card_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/previous_visits_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/image_source_and_document_type_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/patient_documents_view_dialog.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_forms.dart';
import 'package:one/providers/px_patient_forms.dart';
import 'package:one/providers/px_patient_previous_visits.dart';
import 'package:one/providers/px_s3_patient_documents.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:provider/provider.dart';

class PatientInfoCardActions extends StatelessWidget {
  const PatientInfoCardActions({
    super.key,
    required this.patient,
  });
  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return ThemedPopupmenuBtn<void>(
      tooltip: context.loc.patientActions,
      icon: const Icon(Icons.add_reaction),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Row(
              children: [
                const Icon(Icons.event_available_rounded),
                SizedBox(width: 4),
                Text(context.loc.addNewVisit),
              ],
            ),
            onTap: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_Patient_AddNewVisit,
                context,
              );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(
                      permission: _perm.permission,
                    );
                  },
                );
                return;
              }
              final _visitDto = await showDialog<Visit?>(
                context: context,
                builder: (context) {
                  return ChangeNotifierProvider(
                    create: (context) => PxAddNewVisitDialog(
                      context: context,
                    ),
                    child: AddNewVisitDialog(
                      patient: patient,
                    ),
                  );
                },
              );
              if (_visitDto == null) {
                return;
              }
              //todo:
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await context.read<PxVisits>().addNewVisit(
                      _visitDto,
                    );
                    //todo: notify patient with visit details && entry number => manual
                    //todo: generate bookkeeping entry based on the state of the visit
                  },
                  duration: const Duration(milliseconds: 500),
                );
              }
              if (context.mounted) {
                GoRouter.of(context).goNamed(
                  AppRouter.app,
                  pathParameters: defaultPathParameters(
                    context,
                  ),
                );
              }
            },
          ),
          PopupMenuItem(
            child: Row(
              children: [
                const Icon(Icons.sick_sharp),
                SizedBox(width: 4),
                Text(context.loc.patientVisits),
              ],
            ),
            onTap: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_Patient_PreviousVisits,
                context,
              );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(
                      permission: _perm.permission,
                    );
                  },
                );
                return;
              }
              //todo: build previous visits dialog ui && logic
              await showDialog(
                context: context,
                builder: (context) {
                  return ChangeNotifierProvider(
                    key: ValueKey(patient.id),
                    create: (context) => PxPatientPreviousVisits(
                      api: PatientPreviousVisitsApi(
                        patient_id: patient.id,
                      ),
                    ),
                    child: PreviousVisitsDialog(),
                  );
                },
              );
            },
          ),
          PopupMenuItem(
            child: Row(
              children: [
                const Icon(FontAwesomeIcons.idCard),
                SizedBox(width: 4),
                Text(context.loc.patientCard),
              ],
            ),
            onTap: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_Patient_InfoCard,
                context,
              );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(
                      permission: _perm.permission,
                    );
                  },
                );
                return;
              }
              await showDialog(
                context: context,
                builder: (context) {
                  return PatientIdCardDialog(
                    patient: patient,
                  );
                },
              );
            },
          ),
          PopupMenuItem(
            child: Row(
              children: [
                const Icon(Icons.attach_file),
                SizedBox(width: 4),
                Text(context.loc.patientForms),
              ],
            ),
            onTap: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_Patient_Forms,
                context,
              );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(
                      permission: _perm.permission,
                    );
                  },
                );
                return;
              }
              await showDialog(
                context: context,
                builder: (context) {
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => PxForms(
                          api: FormsApi(
                            doc_id: context.read<PxAuth>().doc_id,
                          ),
                        ),
                      ),
                      ChangeNotifierProvider(
                        create: (context) => PxPatientForms(
                          api: PatientFormsApi(
                            patient_id: patient.id,
                            doc_id: context.read<PxAuth>().doc_id,
                          ),
                        ),
                      ),
                    ],
                    child: PatientFormsDialog(),
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
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_Patient_ViewDocuments,
                context,
              );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(
                      permission: _perm.permission,
                    );
                  },
                );
                return;
              }
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
                      state: S3PatientDocumentsPxState.documents_one_patient,
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
            onTap: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_Patient_AddDocument,
                context,
              );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(
                      permission: _perm.permission,
                    );
                  },
                );
                return;
              }
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
                patient_id: patient.id,
                related_visit_id: '',
                related_visit_data_id: '',
                document_type_id: _imgSrcDocType.document_type.id,
                document_url: '',
                created: DateTime.now().unTimed,
              );

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await context.read<PxS3PatientDocuments>().addPatientDocument(
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
        ];
      },
    );
  }
}
