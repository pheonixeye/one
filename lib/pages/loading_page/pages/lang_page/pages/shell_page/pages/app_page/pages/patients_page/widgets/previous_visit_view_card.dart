import 'package:go_router/go_router.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/app_constants/visit_status.dart';
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/error_dialog.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PreviousVisitViewCard extends StatelessWidget {
  const PreviousVisitViewCard({
    super.key,
    required this.visit,
    required this.index,
    this.showIndexNumber = true,
    this.showPatientName = false,
  });
  final VisitExpanded visit;
  final int index;
  final bool showIndexNumber;
  final bool showPatientName;
  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Column(
                spacing: 8,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      SmBtn(
                        child: showIndexNumber
                            ? Text('${index + 1}'.toArabicNumber(context))
                            : SizedBox(),
                      ),
                      Text(
                        DateFormat(
                          'dd - MM - yyyy',
                          l.lang,
                        ).format(visit.visit_date),
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsetsDirectional.only(start: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    if (showPatientName) ...[
                      Row(
                        spacing: 8,

                        children: [
                          Text(
                            l.isEnglish ? 'Patient Name:' : 'اسم المريض:',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Text(visit.patient.name),
                        ],
                      ),
                    ],
                    Row(
                      spacing: 8,

                      children: [
                        Text(
                          l.isEnglish ? 'Doctor:' : 'دكتور:',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          l.isEnglish
                              ? visit.doctor.name_en
                              : visit.doctor.name_ar,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,

                      children: [
                        Text(
                          l.isEnglish ? 'Clinic:' : 'عيادة:',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          l.isEnglish
                              ? visit.clinic.name_en
                              : visit.clinic.name_ar,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,

                      children: [
                        Text(
                          l.isEnglish ? 'Visit:' : 'نوع الزيارة:',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          VisitTypeEnum.visitType(
                            visit.visit_type,
                            l.isEnglish,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        Text(
                          l.isEnglish ? 'Attendance:' : 'الحضور:',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),

                        if (visit.visit_status ==
                            context.read<PxAppConstants>().attended.name_en)
                          const Icon(Icons.check, color: Colors.green)
                        else
                          const Icon(Icons.close, color: Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
              trailing: SmBtn(
                tooltip: context.loc.openVisit,
                child: const Icon(Icons.arrow_forward),
                onPressed: () async {
                  //@permission
                  final _auth = context.read<PxAuth>();

                  final _perm = _auth.isActionPermitted(
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
                  GoRouter.of(context).goNamed(
                    AppRouter.visit_clinical_notes,
                    pathParameters: {
                      ...defaultPathParameters(context),
                      'visit_id': visit.id,
                    },
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
