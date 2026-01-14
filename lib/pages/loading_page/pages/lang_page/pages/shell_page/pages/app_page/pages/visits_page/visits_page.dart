import 'package:one/extensions/number_translator.dart';
import 'package:one/extensions/visit_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/logic/excel_file_prep.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visit_data_table_columns.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visit_options_btn.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/not_permitted_template_page.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visits_filter_header.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_filter.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({super.key});

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  late final ScrollController _verticalScroll;
  late final ScrollController _horizontalScroll;

  @override
  void initState() {
    super.initState();
    _verticalScroll = ScrollController();
    _horizontalScroll = ScrollController();
  }

  @override
  void dispose() {
    _verticalScroll.dispose();
    _horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer5<
      PxAppConstants,
      PxDoctor,
      PxClinics,
      PxVisitFilter,
      PxLocale
    >(
      builder: (context, a, d, c, v, l, _) {
        while (a.constants == null ||
            d.allDoctors == null ||
            c.result == null ||
            v.concisedVisits == null) {
          return CentralLoading();
        }
        //@permission
        final _perm = context.read<PxAuth>().isActionPermitted(
          PermissionEnum.User_Visits_Read,
          context,
        );
        while (!_perm.isAllowed) {
          return NotPermittedTemplatePage(title: context.loc.visits);
        }
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //todo: add filter by doctor, clinic
              VisitsFilterHeader(),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (v.concisedVisits == null || a.constants == null) {
                      return CentralLoading();
                    }
                    while (v.concisedVisits is ApiErrorResult) {
                      return CentralError(
                        code: (v.concisedVisits as ApiErrorResult).errorCode,
                        toExecute: v.retry,
                      );
                    }
                    final _items = v.filteredConcisedVisits;
                    while (_items.isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noVisitsFoundForSelectedDateRange,
                      );
                    }
                    return Scrollbar(
                      controller: _verticalScroll,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _verticalScroll,
                        restorationId: 'v-vertical',
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: [
                            Expanded(
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: _horizontalScroll,
                                child: SingleChildScrollView(
                                  controller: _horizontalScroll,
                                  restorationId: 'v-horizontal',
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    border: TableBorder.all(),
                                    dividerThickness: 2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    headingRowColor: WidgetStatePropertyAll(
                                      Colors.amber.shade50,
                                    ),
                                    columns: buildDataColumns(context),
                                    rows: [
                                      ..._items.map((x) {
                                        final index = _items.indexOf(x);
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  '${index + 1}'.toArabicNumber(
                                                    context,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //todo
                                            DataCell(
                                              VisitOptionsBtn(visit: x),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Builder(
                                                  builder: (context) {
                                                    final _doctor = d.allDoctors
                                                        ?.firstWhere(
                                                          (e) =>
                                                              e.id == x.doc_id,
                                                        );
                                                    return Text(
                                                      l.isEnglish
                                                          ? _doctor?.name_en ??
                                                                ''
                                                          : _doctor?.name_ar ??
                                                                '',
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Builder(
                                                builder: (context) {
                                                  final _isAttended =
                                                      x.visit_status ==
                                                      a.attended.name_en;
                                                  return Center(
                                                    child: Icon(
                                                      _isAttended
                                                          ? Icons.check
                                                          : Icons.close,
                                                      color: _isAttended
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  DateFormat(
                                                    'dd - MM - yyyy',
                                                    l.lang,
                                                  ).format(
                                                    x.visit_date,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Builder(
                                                  builder: (context) {
                                                    final _visitType = a
                                                        .constants
                                                        ?.visitType
                                                        .firstWhere(
                                                          (e) =>
                                                              e.name_en ==
                                                              x.visit_type,
                                                        );
                                                    return Text(
                                                      l.isEnglish
                                                          ? _visitType
                                                                    ?.name_en ??
                                                                ''
                                                          : _visitType
                                                                    ?.name_ar ??
                                                                '',
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Builder(
                                                  builder: (context) {
                                                    final _clinic =
                                                        (c.result
                                                                as ApiDataResult<
                                                                  List<Clinic>
                                                                >)
                                                            .data
                                                            .firstWhere(
                                                              (e) =>
                                                                  e.id ==
                                                                  x.clinic_id,
                                                            );
                                                    return Text(
                                                      l.isEnglish
                                                          ? _clinic.name_en
                                                          : _clinic.name_ar,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  x.formattedShift(context),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(x.added_by),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: SmBtn(
            tooltip: context.loc.exportToExcel,
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_Visits_PrintReciept,
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
              final _visits = v.filteredConcisedVisits;
              final _excel = ExcelFilePrep(
                visits: _visits,
                from: v.from,
                to: v.to,
              );
              await shellFunction(
                context,
                toExecute: () async {
                  await _excel.save(
                    constants: a.constants!,
                    doctors: d.allDoctors!,
                  );
                },
              );
            },
            child: const Icon(Icons.file_open),
          ),
        );
      },
    );
  }
}
