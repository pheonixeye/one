import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/visit_data_api.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/models/visits/_visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/previous_visit_view_card.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_previous_visits.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailedPreviousPatientVisitsDialog extends StatefulWidget {
  const DetailedPreviousPatientVisitsDialog({super.key});

  @override
  State<DetailedPreviousPatientVisitsDialog> createState() =>
      _DetailedPreviousPatientVisitsDialogState();
}

class _DetailedPreviousPatientVisitsDialogState
    extends State<DetailedPreviousPatientVisitsDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  Visit? _selectedVisit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPatientPreviousVisits, PxLocale>(
      builder: (context, p, l, _) {
        while (p.data == null) {
          return CentralLoading();
        }
        while (p.data is ApiErrorResult) {
          return CentralError(
            code: (p.data as ApiErrorResult).errorCode,
            toExecute: p.retry,
          );
        }
        while (p.data != null &&
            (p.data! as ApiDataResult<List<Visit>>).data.isEmpty) {
          return CentralNoItems(
            message: context.loc.noVisitsFoundForThisPatient,
          );
        }
        final _data = (p.data as ApiDataResult<List<Visit>>).data;
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.previousPatientVisits,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '(${_data.first.patient.name})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
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
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: context.loc.previousPatientVisits),
                    Tab(text: context.loc.visitData),
                  ],
                  onTap: (value) {
                    if (_selectedVisit == null && value == 1) {
                      _tabController.animateTo(0);
                      return;
                    }
                    if (value == 0) {
                      _selectedVisit = null;
                    }
                  },
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      //visit list side
                      Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _data.length,
                              itemBuilder: (context, index) {
                                final item = _data[index];
                                return InkWell(
                                  mouseCursor: SystemMouseCursors.click,
                                  onTap: () async {
                                    _selectedVisit = item;
                                    _tabController.animateTo(1);
                                  },
                                  child: PreviousVisitViewCard(
                                    index: index,
                                    item: item,
                                  ),
                                );
                              },
                            ),
                          ),
                          Row(
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
                                  );
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
                                child: Text(
                                  '-${p.page}-'.toArabicNumber(context),
                                ),
                              ),
                              IconButton.outlined(
                                tooltip: context.loc.next,
                                onPressed: () async {
                                  await shellFunction(
                                    context,
                                    toExecute: () async {
                                      await p.nextPage();
                                    },
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //visit details side
                      ChangeNotifierProvider(
                        create: (context) => PxVisitData(
                          api: VisitDataApi(visit_id: _selectedVisit!.id),
                        ),
                        child: Consumer<PxVisitData>(
                          builder: (context, v, _) {
                            while (v.result == null) {
                              return CentralLoading();
                            }
                            while (v.result is ApiErrorResult) {
                              return CentralError(
                                code: (v.result as ApiErrorResult).errorCode,
                                toExecute: v.retry,
                              );
                            }
                            final _data =
                                (v.result as ApiDataResult<VisitData>).data;
                            return ListView(
                              children: [
                                _selectedVisit == null
                                    ? SizedBox()
                                    : PreviousVisitViewCard(
                                        item: _selectedVisit!,
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
                                      leading: const SmBtn(),
                                      title: Text(context.loc.visitForms),
                                      children: [
                                        ..._data.forms.map((f) {
                                          return ExpansionTile(
                                            initiallyExpanded: true,
                                            title: Row(
                                              spacing: 8,
                                              children: [
                                                CircleAvatar(),
                                                Text(
                                                  l.isEnglish
                                                      ? f.name_en
                                                      : f.name_ar,
                                                ),
                                              ],
                                            ),
                                            children: [
                                              ..._data.forms_data
                                                  .firstWhere(
                                                    (x) => x.form_id == f.id,
                                                  )
                                                  .form_data
                                                  .map((d) {
                                                    return ListTile(
                                                      title: Row(
                                                        spacing: 8,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 8,
                                                          ),
                                                          CircleAvatar(
                                                            radius: 8,
                                                          ),
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
                                                          children: [
                                                            Text(d.field_value),
                                                          ],
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
                                      leading: const SmBtn(),
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
                                              padding:
                                                  const EdgeInsetsDirectional.only(
                                                    start: 50.0,
                                                  ),
                                              child: Builder(
                                                builder: (context) {
                                                  final _dose =
                                                      _data.drug_data[x.id];
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
                                      leading: const SmBtn(),
                                      title: Text(context.loc.visitLabs),
                                      children: [
                                        ..._data.labs.map((x) {
                                          return ListTile(
                                            title: Row(
                                              spacing: 8,
                                              children: [
                                                CircleAvatar(),
                                                Text(
                                                  l.isEnglish
                                                      ? x.name_en
                                                      : x.name_ar,
                                                ),
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
                                      leading: const SmBtn(),
                                      title: Text(context.loc.visitRads),
                                      children: [
                                        ..._data.rads.map((x) {
                                          return ListTile(
                                            title: Row(
                                              spacing: 8,
                                              children: [
                                                CircleAvatar(),
                                                Text(
                                                  l.isEnglish
                                                      ? x.name_en
                                                      : x.name_ar,
                                                ),
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
                                      leading: const SmBtn(),
                                      title: Text(context.loc.visitProcedures),
                                      children: [
                                        ..._data.procedures.map((x) {
                                          return ListTile(
                                            title: Row(
                                              spacing: 8,
                                              children: [
                                                CircleAvatar(),
                                                Text(
                                                  l.isEnglish
                                                      ? x.name_en
                                                      : x.name_ar,
                                                ),
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
                                      leading: const SmBtn(),
                                      title: Text(context.loc.visitSupplies),
                                      children: [
                                        ..._data.supplies.map((x) {
                                          return ListTile(
                                            title: Row(
                                              spacing: 8,
                                              children: [
                                                CircleAvatar(),
                                                Text(
                                                  l.isEnglish
                                                      ? x.name_en
                                                      : x.name_ar,
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    final _itemAmount = _data
                                                        .supplies_data?[x.id];
                                                    return Text(
                                                      '(${_itemAmount.toString()})',
                                                    );
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
                            );
                          },
                        ),
                      ),
                    ],
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
