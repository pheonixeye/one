import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/bookkeeping/bookkeeping_direction.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/models/bookkeeping/bookkeeping_name.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_bookkeeping.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailedViewBookKeeping extends StatefulWidget {
  const DetailedViewBookKeeping({super.key});

  @override
  State<DetailedViewBookKeeping> createState() =>
      _DetailedViewBookKeepingState();
}

class _DetailedViewBookKeepingState extends State<DetailedViewBookKeeping> {
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
          final _items =
              (b.result as ApiDataResult<List<BookkeepingItem>>).data;

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
                            DataColumn(label: Text(context.loc.date)),
                            DataColumn(label: Text(context.loc.operation)),
                            DataColumn(label: Text(context.loc.bkType)),
                            DataColumn(label: Text(context.loc.amount)),
                            DataColumn(label: Text(context.loc.autoAdd)),
                            DataColumn(label: Text(context.loc.addedBy)),
                          ],
                          rows: [
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
                                    Text(
                                      DateFormat(
                                        'dd - MM - yyyy',
                                        l.lang,
                                      ).format(x.created),
                                    ),
                                  ),
                                  DataCell(
                                    InkWell(
                                      onTap: x.auto_add
                                          ? () async {
                                              //TODO: allow for finding item details
                                            }
                                          : null,
                                      child: Text(
                                        l.isEnglish
                                            ? x.item_name
                                            : BookkeepingName.fromString(
                                                x.item_name,
                                              ).ar(),
                                      ),
                                    ),
                                  ),
                                  DataCell(switch (x.type) {
                                    BookkeepingDirection.IN => const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.green,
                                    ),
                                    BookkeepingDirection.OUT => const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.red,
                                    ),
                                    BookkeepingDirection.NONE => const Icon(
                                      Icons.mobiledata_off_rounded,
                                      color: Colors.blue,
                                    ),
                                  }),
                                  DataCell(
                                    Text(
                                      '${x.amount} ${context.loc.egp}'
                                          .toArabicNumber(context),
                                    ),
                                  ),
                                  DataCell(
                                    Icon(
                                      x.auto_add ? Icons.check : Icons.close,
                                      color: x.auto_add
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  DataCell(Text(x.added_by.name)),
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
