import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/discount_managment_row.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/entry_number_column.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/progress_status_row.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/visit_details_btn.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/visit_shift_row.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/visit_status_row.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/visit_type_row.dart';
import 'package:flutter/material.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:provider/provider.dart';

class VisitViewCard extends StatelessWidget {
  const VisitViewCard({super.key, required this.visit, required this.index});
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
          child: Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                        children: [
                          VisitTypeRow(
                            visit: visit,
                          ),
                          //visit shift row
                          VisitShiftRow(
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
                    ),
                  ),
                  //enter visit details page btn
                  VisitDetailsBtn(
                    visit: visit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
