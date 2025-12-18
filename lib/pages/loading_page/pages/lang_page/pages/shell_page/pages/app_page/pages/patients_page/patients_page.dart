import 'package:one/core/api/patient_document_api.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_patient_documents.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/api_result_mapper.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/create_edit_patient_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/patient_info_card.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/search_patients_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patients.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  late final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxPatients>(
      builder: (context, p, _) {
        return Scaffold(
          floatingActionButton: SmBtn(
            tooltip: context.loc.addNewPatient,
            onPressed: () async {
              //todo: Add new patient file dialog
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_Patient_AddNew,
                context,
              );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(permission: _perm.permission);
                  },
                );
                return;
              }
              final _patient = await showDialog<Patient?>(
                context: context,
                builder: (context) {
                  return CreateEditPatientDialog();
                },
              );
              if (_patient == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await p.createPatientProfile(_patient);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              const SearchPatientsHeader(),
              Expanded(
                child: Consumer<PxLocale>(
                  builder: (context, l, _) {
                    while (p.data == null) {
                      return const CentralLoading();
                    }
                    if (p.data is ApiErrorResult) {
                      return CentralError(
                        code: (p.data as ApiErrorResult).errorCode,
                        toExecute: p.fetchPatients,
                      );
                    } else {
                      while (p.data != null &&
                          (p.data! as PatientDataResult).data.isEmpty) {
                        return Center(
                          child: Card.outlined(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(context.loc.noPatientsFound),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _controller,
                        itemCount: (p.data! as PatientDataResult).data.length,
                        itemBuilder: (context, index) {
                          final item =
                              (p.data! as PatientDataResult).data[index];
                          return ChangeNotifierProvider.value(
                            key: ValueKey(item),
                            value: PxPatientDocuments(
                              api: PatientDocumentApi(patient_id: item.id),
                            ),
                            child: PatientInfoCard(patient: item, index: index),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(
                      tooltip: context.loc.previous,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await p.previousPage();
                          },
                          duration: const Duration(milliseconds: 100),
                        );
                        _controller.animateTo(
                          0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('- ${p.page} -'),
                    ),
                    IconButton.outlined(
                      tooltip: context.loc.next,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await p.nextPage();
                          },
                          duration: const Duration(milliseconds: 100),
                        );
                        _controller.animateTo(
                          0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
