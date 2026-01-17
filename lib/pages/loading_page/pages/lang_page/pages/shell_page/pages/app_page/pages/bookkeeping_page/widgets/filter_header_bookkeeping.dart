import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/widgets/print_bookkeeping_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/widgets/show_bookkeeping_details_dialog.dart';
import 'package:one/providers/px_bookkeeping.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class FilterHeaderBookkeeping extends StatefulWidget {
  const FilterHeaderBookkeeping({super.key});

  @override
  State<FilterHeaderBookkeeping> createState() =>
      _FilterHeaderBookkeepingState();
}

class _FilterHeaderBookkeepingState extends State<FilterHeaderBookkeeping> {
  late final TextEditingController _fromController;
  late final TextEditingController _toController;

  @override
  void initState() {
    super.initState();
    final _l = context.read<PxLocale>();
    final _s = context.read<PxBookkeeping>();
    _fromController = TextEditingController(
      text: DateFormat('dd - MM - yyyy', _l.lang).format(_s.from),
    );
    _toController = TextEditingController(
      text: DateFormat('dd - MM - yyyy', _l.lang).format(_s.to),
    );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer2<PxBookkeeping, PxLocale>(
        builder: (context, b, l, _) {
          return ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${context.loc.bookkeeping} - (${l.isEnglish ? b.viewType.en : b.viewType.ar})',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Builder(
                      builder: (context) {
                        while (b.result == null) {
                          return CupertinoActivityIndicator();
                        }
                        while (b.result is ApiErrorResult) {
                          return const SizedBox();
                        }
                        final _items =
                            (b.result as ApiDataResult<List<BookkeepingItem>>)
                                .data;
                        return Row(
                          spacing: 16,
                          children: [
                            SmBtn(
                              onPressed: () async {
                                await shellFunction(
                                  context,
                                  toExecute: () {
                                    b.toggleView();
                                  },
                                );
                              },
                              child: const Icon(Icons.table_view),
                            ),
                            SmBtn(
                              onPressed: () async {
                                if (context.mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ShowBookkeepingDetailsDialog(
                                        items: _items,
                                        from: b.from,
                                        to: b.to,
                                      );
                                    },
                                  );
                                }
                              },
                              child: const Icon(Icons.monetization_on),
                            ),
                            SmBtn(
                              onPressed: () async {
                                if (context.mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PrintBookkeepingDialog(
                                        items: _items,
                                        from: b.from,
                                        to: b.to,
                                      );
                                    },
                                  );
                                }
                              },
                              child: const Icon(Icons.print),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  //TODO: Add filter to show only income or only expenses
                  //TODO: think about adding graphs detailing expenses vs income
                ],
              ),
            ),
            subtitle: const Divider(),
            children: [
              Row(
                spacing: 8,
                children: [
                  Text(context.loc.from),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: _fromController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SmBtn(
                    tooltip: context.loc.pickStartingDate,
                    onPressed: () async {
                      final _from = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().copyWith(
                          year: DateTime.now().year - 5,
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (_from != null) {
                        _fromController.text = DateFormat(
                          'dd - MM - yyyy',
                          l.lang,
                        ).format(_from);
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await b.changeDate(from: _from, to: b.to);
                            },
                          );
                        }
                      }
                    },
                    child: const Icon(Icons.calendar_month_rounded),
                  ),
                  Text(context.loc.to),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: _toController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SmBtn(
                    tooltip: context.loc.pickEndingDate,
                    onPressed: () async {
                      final _to = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().copyWith(
                          year: DateTime.now().year - 5,
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (_to != null) {
                        _toController.text = DateFormat(
                          'dd - MM - yyyy',
                          l.lang,
                        ).format(_to);
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await b.changeDate(from: b.from, to: _to);
                            },
                          );
                        }
                      }
                    },
                    child: const Icon(Icons.calendar_month_rounded),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
