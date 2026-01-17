import 'package:intl/intl.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_bookkeeping.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FocusedViewBookkeepingOthers extends StatefulWidget {
  const FocusedViewBookkeepingOthers({super.key});

  @override
  State<FocusedViewBookkeepingOthers> createState() =>
      _FocusedViewBookkeepingOthersState();
}

class _FocusedViewBookkeepingOthersState
    extends State<FocusedViewBookkeepingOthers> {
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
          final _items = b.bookkeepingOthers;

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
                            //todo: format
                            DataColumn(label: Text(context.loc.number)),
                            DataColumn(label: Text(context.loc.operationName)),
                            DataColumn(
                              label: Text(context.loc.operationsDetails),
                            ),
                            DataColumn(label: Text(context.loc.amount)),
                            DataColumn(label: Text(context.loc.date)),
                            DataColumn(label: Text(context.loc.addedBy)),
                          ],
                          rows: [
                            //todo: format
                            ..._items.map((x) {
                              final _index = _items.indexOf(x);

                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      '${_index + 1}'.toArabicNumber(context),
                                    ),
                                  ),
                                  DataCell(
                                    Text(x.item_name),
                                  ),
                                  DataCell(
                                    Text(x.update_reason),
                                  ),
                                  DataCell(
                                    Text(
                                      '${x.amount} ${context.loc.egp}'
                                          .toArabicNumber(context),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      DateFormat(
                                        'dd-MM-yyyy',
                                        l.lang,
                                      ).format(x.created),
                                    ),
                                  ),
                                  DataCell(
                                    Text(x.added_by),
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
    );
  }
}
