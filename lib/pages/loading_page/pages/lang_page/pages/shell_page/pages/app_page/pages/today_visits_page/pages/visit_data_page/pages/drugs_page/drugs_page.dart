import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/drugs_page/add_drugs_to_visit_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/drugs_page/drug_dose_view_edit_card.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class VisitDrugsPage extends StatelessWidget {
  const VisitDrugsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitData, PxLocale>(
      builder: (context, v, l, _) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              while (v.result == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult) {
                return CentralError(
                  code: (v.result as ApiErrorResult).errorCode,
                  toExecute: v.retry,
                );
              }
              while ((v.result as ApiDataResult<VisitData>)
                  .data
                  .drugs
                  .isEmpty) {
                return Column(
                  children: [
                    VisitDetailsPageInfoHeader(
                      patient:
                          (v.result as ApiDataResult<VisitData>).data.patient,
                      title: context.loc.visitDrugs,
                      iconData: FontAwesomeIcons.prescription,
                    ),
                    Expanded(
                      child: Center(
                        child: CentralNoItems(
                          message: context.loc.noItemsFound,
                        ),
                      ),
                    ),
                  ],
                );
              }
              final _items = (v.result as ApiDataResult<VisitData>).data.drugs;
              final _doses =
                  (v.result as ApiDataResult<VisitData>).data.drug_data;
              return Column(
                children: [
                  VisitDetailsPageInfoHeader(
                    patient:
                        (v.result as ApiDataResult<VisitData>).data.patient,
                    title: context.loc.visitDrugs,
                    iconData: FontAwesomeIcons.prescription,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final _item = _items[index];
                        return DrugDoseViewEditCard(
                          item: _item,
                          index: index,
                          dose: _doses[_item.id],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: SmBtn(
            tooltip: '${context.loc.add} ${context.loc.visitDrugs}',
            onPressed: () async {
              final _mappedIds = (v.result as ApiDataResult<VisitData>)
                  .data
                  .drugs
                  .map((e) => e.id)
                  .toList();
              final _newDrugItems = await showDialog<List<String>?>(
                context: context,
                builder: (context) {
                  return AddDrugsToVisitDialog(drugs_ids: _mappedIds);
                },
              );
              if (_newDrugItems == null || _newDrugItems.isEmpty) {
                return;
              }

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await v.updateDrugsListInVisit(_newDrugItems);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
