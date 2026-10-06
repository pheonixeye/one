import 'package:go_router/go_router.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/visit_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/app_constants/patient_progress_status.dart';
import 'package:one/models/app_constants/visit_status.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/discount_managment_row.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/entry_number_column.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/progress_status_row.dart';
// import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/visit_details_btn.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/visit_referral_row.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/visit_shift_row.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/visit_status_row.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/visit_type_row.dart';
import 'package:flutter/material.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/error_dialog.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:provider/provider.dart';

class VisitViewCard extends StatelessWidget {
  const VisitViewCard({
    super.key,
    required this.visit,
    required this.index,
  });
  final VisitExpanded visit;
  final int index;

  @override
  Widget build(BuildContext context) {
    //todo: restrucutre into smaller widgets
    return Consumer3<PxAppConstants, PxVisits, PxLocale>(
      builder: (context, a, v, l, _) {
        while (a.constants == null) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: Card.outlined(
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 60,
                  child: Center(
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: PatientProgressStatusEnum.member(
                visit.patient_progress_status,
              ).getCardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: PatientProgressStatusEnum.member(
                  visit.patient_progress_status,
                ).getCardBorderColor,
              ),
            ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  //
                  //@permission
                  final _auth = context.read<PxAuth>();

                  final _perm = _auth.isActionPermitted(
                    PermissionEnum.Admin,
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
                  if (visit.visit_status == VisitStatusEnum.NotAttended.en) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return ErrorDialog(
                          message: context.loc.visitNotAttended,
                        );
                      },
                    );
                    return;
                  }
                  if (_auth.doc_id != visit.doc_id) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return ErrorDialog(
                          message: context.loc.cannotOpenAVisitByAnotherDoctor,
                        );
                      },
                    );
                    return;
                  }
                  if (visit.patient_progress_status ==
                      PatientProgressStatusEnum.InWaiting.en) {
                    await shellFunction(
                      context,
                      toExecute: () async {
                        await v.updateVisit(
                          visit: visit,
                          key: 'patient_progress_status',
                          value: PatientProgressStatusEnum.InConsultation.en,
                        );
                      },
                      duration: const Duration(milliseconds: 260),
                    );
                  }
                  if (context.mounted) {
                    GoRouter.of(context).goNamed(
                      AppRouter.visit_clinical_notes,
                      pathParameters: defaultPathParameters(context)
                        ..addAll({'visit_id': visit.id}),
                      extra: visit.patient_id,
                    );
                  }
                },
                child: Row(
                  children: [
                    //entry number column
                    EntryNumberColumn(
                      visit: visit,
                    ),
                    //data & action rows
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VisitTypeRow(
                              visit: visit,
                            ),

                            //visit shift row
                            const SizedBox(height: 8),
                            //visit referral row
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                VisitShiftRow(
                                  visit: visit,
                                ),
                                VisitReferralRow(
                                  visit: visit,
                                ),
                                //visit status toggle
                                VisitStatusRow(
                                  visit: visit,
                                ),
                                //patient progress status toogle
                                ProgressStatusRow(
                                  visit: visit,
                                ),
                                //discount managment row
                                DiscountManagmentRow(visit: visit),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //enter visit details page btn
                    // VisitDetailsBtn(
                    //   visit: visit,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
