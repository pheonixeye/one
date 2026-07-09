import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class VisitClinicalNotesPage extends StatelessWidget {
  const VisitClinicalNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitData, PxLocale>(
      builder: (context, vd, l, _) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              while (vd.result == null) {
                return const CentralLoading();
              }

              while (vd.result is ApiErrorResult) {
                return CentralError(
                  code: (vd.result as ApiErrorResult).errorCode,
                  toExecute: vd.retry,
                );
              }

              ///TODO: clinical notes empty - first visit
              // while ((vd.result as ApiDataResult<VisitData>)
              //     .data
              //     .forms
              //     .isEmpty) {
              //   return Column(
              //     children: [
              //       VisitDetailsPageInfoHeader(
              //         patient:
              //             (v.result as ApiDataResult<VisitData>).data.patient,
              //         title: context.loc.visitForms,
              //         iconData: Icons.edit_document,
              //       ),
              //       Expanded(
              //         child: CentralNoItems(message: context.loc.noItemsFound),
              //       ),
              //     ],
              //   );
              // }
              // final _data = (vd.result as ApiDataResult<VisitData>).data;
              //TODO: craft UI
              return Column(
                children: [
                  VisitDetailsPageInfoHeader(
                    patient:
                        (vd.result as ApiDataResult<VisitData>).data.patient,
                    title: context.loc.clinicalNotes,
                    iconData: Icons.edit_document,
                  ),
                  Expanded(
                    child: CentralNoItems(message: context.loc.noItemsFound),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
