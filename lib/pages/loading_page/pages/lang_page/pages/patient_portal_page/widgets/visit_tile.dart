import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/widgets/visit_documents_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_portal.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class VisitTile extends StatelessWidget {
  const VisitTile({
    super.key,
    required this.item,
    required this.index,
  });
  final VisitExpanded item;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPatientPortal, PxLocale>(
      builder: (context, p, l, _) {
        return Card.outlined(
          elevation: 6,
          color: Colors.amber.shade50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () async {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await p.fetchVisitDocuments(item.id);
                  },
                  duration: const Duration(milliseconds: 500),
                );
                if (context.mounted &&
                    p.visitDocuments != null &&
                    p.visitDocuments is! ApiErrorResult) {
                  final _docs =
                      (p.visitDocuments
                              as ApiDataResult<
                                List<PatientDocumentWithDocumentType>
                              >)
                          .data;
                  if (_docs.isEmpty) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return CentralNoItems(
                          message: context.loc.noDocumentsFoundForThisVisit,
                        );
                      },
                    );
                  } else {
                    await showDialog<void>(
                      context: context,
                      builder: (context) {
                        return VisitDocumentsDialog(
                          docs: _docs,
                        );
                      },
                    );
                  }
                }
              },
              title: Row(
                spacing: 8,
                children: [
                  SmBtn(
                    child: Text(
                      '${index + 1}'.toArabicNumber(context),
                    ),
                  ),
                  Text(
                    DateFormat(
                      'dd-MM-yyyy',
                      l.lang,
                    ).format(item.visit_date),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 50.0,
                ),
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: context.loc.doctor,
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: l.isEnglish
                                ? item.doctor.name_en
                                : item.doctor.name_ar,
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: context.loc.speciality,
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: l.isEnglish
                                ? item.doctor.spec_en
                                : item.doctor.spec_ar,
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: context.loc.clinic,
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: l.isEnglish
                                ? item.clinic.name_en
                                : item.clinic.name_ar,
                          ),
                        ],
                      ),
                    ),
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
