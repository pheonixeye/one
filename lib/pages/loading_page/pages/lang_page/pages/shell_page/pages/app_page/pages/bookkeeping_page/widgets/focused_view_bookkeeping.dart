import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/visit_filter_api.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/widgets/operation_detail_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_bookkeeping.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_one_visit.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FocusedViewBookkeeping extends StatefulWidget {
  const FocusedViewBookkeeping({super.key});

  @override
  State<FocusedViewBookkeeping> createState() => _FocusedViewBookkeepingState();
}

class _FocusedViewBookkeepingState extends State<FocusedViewBookkeeping> {
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
    return Expanded(
      child: Consumer3<PxBookkeeping, PxAppConstants, PxLocale>(
        builder: (context, b, a, l, _) {
          while (a.constants == null || b.result == null) {
            return const CentralLoading();
          }

          while (b.result is ApiErrorResult) {
            return CentralError(
              code: (b.result as ApiErrorResult).errorCode,
              toExecute: b.retry,
            );
          }

          while (b.result != null &&
              (b.result is ApiDataResult) &&
              (b.result as ApiDataResult<List<BookkeepingItem>>).data.isEmpty) {
            return CentralNoItems(
              message: context.loc.noBookkeepingEntriesFoundInSelectedDate,
            );
          }
          final _items = b.foldedBookkeeping;

          return Scrollbar(
            controller: _verticalScroll,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _verticalScroll,
              restorationId: 'bk-vertical',
              scrollDirection: Axis.vertical,
              child: Row(
                children: [
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _horizontalScroll,
                      child: SingleChildScrollView(
                        controller: _horizontalScroll,
                        restorationId: 'bk-horizontal',
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
                          columns: [
                            DataColumn(label: Text(context.loc.number)),
                            DataColumn(label: Text(context.loc.link)),
                            DataColumn(label: Text(context.loc.amount)),
                            DataColumn(label: Text(context.loc.operation)),
                          ],
                          rows: [
                            ..._items.entries.map((x) {
                              final _index = _items.keys.toList().indexOf(
                                x.key,
                              );
                              final _id = x.key.split('-').first;
                              final _collection = x.key.split('-').last;
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      '${_index + 1}'.toArabicNumber(context),
                                    ),
                                  ),
                                  DataCell(
                                    InkWell(
                                      hoverColor: Colors.amber.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_id),
                                      ),
                                      onTap: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ChangeNotifierProvider(
                                              create: (context) => PxOneVisit(
                                                api: const VisitFilterApi(),
                                                visit_id: _id,
                                              ),
                                              child: OperationDetailDialog(
                                                item_id: _id,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${x.value} ${context.loc.egp}'
                                          .toArabicNumber(context),
                                    ),
                                  ),
                                  DataCell(Text(_collection)),
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
    );
  }
}
