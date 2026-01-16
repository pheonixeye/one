import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/supply_movements_page/widgets/supply_mov_data_table.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/supply_movements_page/widgets/supply_movement_action_bubble.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/widgets/not_permitted_template_page.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/supplies/supply_movement.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/supply_movements_page/widgets/print_supply_movements_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_supply_movements.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class SupplyMovementsPage extends StatefulWidget {
  const SupplyMovementsPage({super.key});

  @override
  State<SupplyMovementsPage> createState() => _SupplyMovementsPageState();
}

class _SupplyMovementsPageState extends State<SupplyMovementsPage> {
  late final TextEditingController _fromController;
  late final TextEditingController _toController;
  late final l = context.read<PxLocale>();
  late final ScrollController _verticalScroll;
  late final ScrollController _horizontalScroll;

  @override
  void initState() {
    super.initState();
    final _s = context.read<PxSupplyMovements>();
    _fromController = TextEditingController(
      text: DateFormat('dd - MM - yyyy', l.lang).format(_s.from),
    );
    _toController = TextEditingController(
      text: DateFormat('dd - MM - yyyy', l.lang).format(_s.to),
    );
    _verticalScroll = ScrollController();
    _horizontalScroll = ScrollController();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _verticalScroll.dispose();
    _horizontalScroll.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //todo: Change to table layout
    return Consumer3<PxSupplyMovements, PxAppConstants, PxLocale>(
      builder: (context, s, a, l, _) {
        while (a.constants == null) {
          return CentralLoading();
        }
        //@permission
        final _perm = context.read<PxAuth>().isActionPermitted(
          PermissionEnum.User_SupplyMovements_Read,
          context,
        );
        while (!_perm.isAllowed) {
          return NotPermittedTemplatePage(
            title: context.loc.supplyItemsMovement,
          );
        }
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Text(context.loc.supplyItemsMovement)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Builder(
                            builder: (context) {
                              while (s.result == null) {
                                return CupertinoActivityIndicator();
                              }
                              while (s.result is ApiErrorResult) {
                                final _err = (s.result as ApiErrorResult);
                                return CentralError(
                                  toExecute: s.retry,
                                  code: _err.errorCode,
                                );
                              }
                              final _items =
                                  (s.result
                                          as ApiDataResult<
                                            List<SupplyMovement>
                                          >)
                                      .data;
                              return SmBtn(
                                onPressed: () async {
                                  if (context.mounted) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PrintSupplyMovementsDialog(
                                          movements: _items,
                                          fromDate: s.from,
                                          toDate: s.to,
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Icon(Icons.print),
                              );
                            },
                          ),
                        ),
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
                              lastDate: DateTime.now(),
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
                                    await s.changeDate(from: _from, to: s.to);
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
                              lastDate: DateTime.now(),
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
                                    await s.changeDate(from: s.from, to: _to);
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
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (s.result == null || a.constants == null) {
                      return const CentralLoading();
                    }

                    while (s.result is ApiErrorResult) {
                      return CentralError(
                        code: (s.result as ApiErrorResult).errorCode,
                        toExecute: s.retry,
                      );
                    }

                    while (s.result != null &&
                        (s.result is ApiDataResult) &&
                        (s.result as ApiDataResult<List<SupplyMovement>>)
                            .data
                            .isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noSupplyMovementsFound,
                      );
                    }
                    final _items =
                        (s.result as ApiDataResult<List<SupplyMovement>>).data;

                    return buildDataTable(
                      context,
                      l,
                      items: _items,
                      verticalScroll: _verticalScroll,
                      horizontalScroll: _horizontalScroll,
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: const SupplyMovementActionBubble(),
        );
      },
    );
  }
}
