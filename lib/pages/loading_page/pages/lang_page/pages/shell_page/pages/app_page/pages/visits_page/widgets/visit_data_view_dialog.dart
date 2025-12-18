import 'package:one/models/visits/_visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/previous_visit_view_card.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class VisitDataViewDialog extends StatelessWidget {
  const VisitDataViewDialog({super.key, required this.visit});
  final Visit visit;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitData, PxLocale>(
      builder: (context, v, l, _) {
        while (v.result == null) {
          return CentralLoading();
        }
        while (v.result is ApiErrorResult) {
          return CentralError(
            code: (v.result as ApiErrorResult).errorCode,
            toExecute: v.retry,
          );
        }
        final _data = (v.result as ApiDataResult<VisitData>).data;
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.visitData,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '(${_data.patient.name})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            //todo: add visit data in an easy to view way
            child: ListView(
              children: [
                PreviousVisitViewCard(
                  item: visit,
                  index: 0,
                  showIndexNumber: false,
                ),
                //forms
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      leading: SmBtn(onPressed: null),
                      title: Text(context.loc.visitForms),
                      children: [
                        ..._data.forms.map((f) {
                          return ExpansionTile(
                            initiallyExpanded: true,
                            title: Row(
                              spacing: 8,
                              children: [
                                CircleAvatar(),
                                Text(l.isEnglish ? f.name_en : f.name_ar),
                              ],
                            ),
                            children: [
                              ..._data.forms_data
                                  .firstWhere((x) => x.form_id == f.id)
                                  .form_data
                                  .map((d) {
                                    return ListTile(
                                      title: Row(
                                        spacing: 8,
                                        children: [
                                          CircleAvatar(radius: 8),
                                          CircleAvatar(radius: 8),
                                          Text(d.field_name),
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                              start: 50.0,
                                            ),
                                        child: Wrap(
                                          spacing: 8,
                                          children: [Text(d.field_value)],
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                //drugs
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      leading: SmBtn(onPressed: null),
                      title: Text(context.loc.visitDrugs),
                      children: [
                        ..._data.drugs.map((x) {
                          return ListTile(
                            title: Row(
                              spacing: 8,
                              children: [
                                CircleAvatar(),
                                Text(
                                  l.isEnglish
                                      ? x.prescriptionNameEn
                                      : x.prescriptionNameAr,
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 50.0,
                              ),
                              child: Builder(
                                builder: (context) {
                                  final _dose = _data.drug_data[x.id];
                                  return Text(_dose);
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                //labs
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      leading: SmBtn(onPressed: null),
                      title: Text(context.loc.visitLabs),
                      children: [
                        ..._data.labs.map((x) {
                          return ListTile(
                            title: Row(
                              spacing: 8,
                              children: [
                                CircleAvatar(),
                                Text(l.isEnglish ? x.name_en : x.name_ar),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                //rads
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      leading: SmBtn(onPressed: null),
                      title: Text(context.loc.visitRads),
                      children: [
                        ..._data.rads.map((x) {
                          return ListTile(
                            title: Row(
                              spacing: 8,
                              children: [
                                CircleAvatar(),
                                Text(l.isEnglish ? x.name_en : x.name_ar),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                //procedures
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      leading: SmBtn(onPressed: null),
                      title: Text(context.loc.visitProcedures),
                      children: [
                        ..._data.procedures.map((x) {
                          return ListTile(
                            title: Row(
                              spacing: 8,
                              children: [
                                CircleAvatar(),
                                Text(l.isEnglish ? x.name_en : x.name_ar),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                //supplies
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      leading: SmBtn(onPressed: null),
                      title: Text(context.loc.visitSupplies),
                      children: [
                        ..._data.supplies.map((x) {
                          return ListTile(
                            title: Row(
                              spacing: 8,
                              children: [
                                CircleAvatar(),
                                Text(l.isEnglish ? x.name_en : x.name_ar),
                                Builder(
                                  builder: (context) {
                                    final _itemAmount =
                                        _data.supplies_data?[x.id];
                                    return Text('(${_itemAmount.toString()})');
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
