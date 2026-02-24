import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/core/api/reciept_info_api.dart';
import 'package:one/core/api/s3_patient_documents_api.dart';
import 'package:one/core/api/visit_data_api.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/reciept_info.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/patient_documents_view_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/reciept_prepare_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/select_reciept_info_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visit_data_view_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_one_visit_bookkeeping.dart';
import 'package:one/providers/px_reciept_info.dart';
import 'package:one/providers/px_s3_patient_documents.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/providers/px_visit_filter.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VisitOptionsBtn extends StatefulWidget {
  const VisitOptionsBtn({super.key, required this.visit});
  final VisitExpanded visit;

  @override
  State<VisitOptionsBtn> createState() => _VisitOptionsBtnState();
}

class _VisitOptionsBtnState extends State<VisitOptionsBtn> {
  VisitExpanded? _expandedVisit;
  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxVisitFilter, PxRecieptInfo>(
      builder: (context, a, v, r, _) {
        while (a.constants == null) {
          return const Center(child: LinearProgressIndicator());
        }
        return Center(
          child: Row(
            children: [
              InkWell(
                hoverColor: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  //todo: Go to visit Data View Dialog
                  if (_expandedVisit == null) {
                    await shellFunction(
                      context,
                      toExecute: () async {
                        await v.fetchOneExpandedVisit(widget.visit.id);
                        _expandedVisit =
                            (v.expandedSingleVisit
                                    as ApiDataResult<VisitExpanded>)
                                .data;
                      },
                    );
                  }
                  if (context.mounted) {
                    await showDialog<void>(
                      context: context,
                      builder: (context) {
                        return ChangeNotifierProvider(
                          create: (context) => PxVisitData(
                            api: VisitDataApi(
                              visit_id: widget.visit.id,
                              added_by: '${context.read<PxAuth>().user?.name}',
                            ),
                          ),
                          child: VisitDataViewDialog(visit: _expandedVisit!),
                        );
                      },
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.visit.patient.name),
                ),
              ),
              const Spacer(),
              ThemedPopupmenuBtn<void>(
                onOpened: () async {
                  await shellFunction(
                    context,
                    toExecute: () async {
                      await v.fetchOneExpandedVisit(widget.visit.id);
                      _expandedVisit =
                          (v.expandedSingleVisit
                                  as ApiDataResult<VisitExpanded>)
                              .data;
                    },
                  );
                },
                icon: const Icon(Icons.menu),
                tooltip: context.loc.settings,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<void>(
                      onTap: null,
                      padding: const EdgeInsets.all(0),
                      child: InkWell(
                        onTap: () async {
                          //@permission
                          final _perm = context
                              .read<PxAuth>()
                              .isActionPermitted(
                                PermissionEnum.User_Visits_PrintReciept,
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
                          //TODO: add error dialog to add logo first

                          final _info = await showDialog<RecieptInfo?>(
                            context: context,
                            builder: (context) {
                              return ChangeNotifierProvider(
                                create: (context) => PxRecieptInfo(
                                  api: const RecieptInfoApi(),
                                ),
                                child: const SelectRecieptInfoDialog(),
                              );
                            },
                          );

                          if (_info == null) {
                            if (context.mounted) {
                              showIsnackbar(context.loc.noRecieptInfoFound);
                            }
                            return;
                          }
                          if (context.mounted) {
                            await showDialog<void>(
                              context: context,
                              builder: (context) {
                                return ChangeNotifierProvider(
                                  create: (context) => PxOneVisitBookkeeping(
                                    api: BookkeepingApi(
                                      visit_id: widget.visit.id,
                                    ),
                                  ),
                                  child: RecieptPrepareDialog(
                                    visit: _expandedVisit!,
                                    info: _info,
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.receipt_long),
                            SizedBox(width: 4),
                            Text(context.loc.printReciept),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem<void>(
                      onTap: null,
                      padding: const EdgeInsets.all(0),
                      child: ChangeNotifierProvider(
                        create: (context) => PxVisitData(
                          api: VisitDataApi(
                            visit_id: widget.visit.id,
                            added_by: '${context.read<PxAuth>().user?.name}',
                          ),
                        ),
                        child: InkWell(
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_forward),
                              SizedBox(width: 4),
                              Text(context.loc.openVisit),
                            ],
                          ),
                          onTap: () async {
                            //@permission
                            final _perm = context
                                .read<PxAuth>()
                                .isActionPermitted(
                                  PermissionEnum.Admin,
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
                            if (widget.visit.visit_status ==
                                a.notAttended.name_en) {
                              showIsnackbar(context.loc.visitNotAttended);
                              return;
                            }
                            GoRouter.of(context).goNamed(
                              AppRouter.visit_forms,
                              pathParameters: defaultPathParameters(context)
                                ..addAll({'visit_id': widget.visit.id}),
                            );
                            //TODO: Notify FCM to Org Members visit accessed by who
                          },
                        ),
                      ),
                    ),
                    PopupMenuItem<void>(
                      onTap: null,
                      padding: const EdgeInsets.all(0),
                      child: InkWell(
                        child: Row(
                          children: [
                            const Icon(Icons.document_scanner),
                            SizedBox(width: 4),
                            Text(context.loc.visitDocuments),
                          ],
                        ),
                        onTap: () async {
                          if (widget.visit.visit_status ==
                              a.notAttended.name_en) {
                            showIsnackbar(context.loc.visitNotAttended);
                            return;
                          }

                          await showDialog(
                            context: context,
                            builder: (context) {
                              return ChangeNotifierProvider(
                                key: ValueKey(
                                  '${widget.visit.patient_id}/${widget.visit.id}',
                                ),
                                create: (context) => PxS3PatientDocuments(
                                  context: context,
                                  state: S3PatientDocumentsPxState
                                      .documents_one_visit_one_patient,
                                  api: S3PatientDocumentApi(
                                    patient_id: widget.visit.patient_id,
                                    visit_id: widget.visit.id,
                                  ),
                                ),
                                child: PatientDocumentsViewDialog(
                                  patient: widget.visit.patient,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ];
                },
              ),
              SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}
