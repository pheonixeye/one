import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/supplies/supply_movement.dart';
import 'package:one/models/supplies/supply_movement_type.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';

Widget buildDataTable(
  BuildContext context,
  PxLocale l, {
  required List<SupplyMovement>? items,
  required ScrollController verticalScroll,
  required ScrollController horizontalScroll,
}) {
  while (items == null) {
    return CentralLoading();
  }
  return Scrollbar(
    thumbVisibility: true,
    controller: verticalScroll,
    child: SingleChildScrollView(
      controller: verticalScroll,
      restorationId: 'data-table-vertical',
      scrollDirection: Axis.vertical,
      child: Row(
        children: [
          Expanded(
            child: Scrollbar(
              controller: horizontalScroll,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: horizontalScroll,
                restorationId: 'data-table-horizontal',
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
                    DataColumn(
                      label: Text(
                        context.loc.number,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        context.loc.movementDate,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        context.loc.supplyItem,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        context.loc.clinic,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        context.loc.movementDirection,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        context.loc.movementReason,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        context.loc.movementQuantity,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        context.loc.movementAmount,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        context.loc.relatedVisitId,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        context.loc.autoAdd,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        context.loc.addedBy,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  rows: [
                    ...items.map<DataRow>((x) {
                      final _supplyItemMovementType =
                          SupplyMovementType.fromString(x.movement_type);
                      final _index = items.indexOf(x);
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              '${_index + 1}'.toArabicNumber(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              DateFormat(
                                'dd - MM - yyyy',
                                l.lang,
                              ).format(x.created),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              l.isEnglish
                                  ? x.supply_item.name_en
                                  : x.supply_item.name_ar,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              l.isEnglish ? x.clinic.name_en : x.clinic.name_ar,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Tooltip(
                                message: l.isEnglish
                                    ? _supplyItemMovementType.en
                                    : _supplyItemMovementType.ar,
                                child: Icon(
                                  switch (_supplyItemMovementType) {
                                    SupplyMovementType.OUT_IN =>
                                      Icons.arrow_downward,
                                    SupplyMovementType.IN_OUT =>
                                      Icons.arrow_upward,
                                    SupplyMovementType.IN_IN =>
                                      Icons.compare_arrows_rounded,
                                  },
                                  color: switch (_supplyItemMovementType) {
                                    SupplyMovementType.OUT_IN => Colors.red,
                                    SupplyMovementType.IN_OUT => Colors.green,
                                    SupplyMovementType.IN_IN => Colors.blue,
                                  },
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(x.reason, textAlign: TextAlign.center),
                          ),
                          DataCell(
                            Text(
                              '${x.movement_quantity} ${l.isEnglish ? x.supply_item.unit_en : x.supply_item.unit_ar}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              '${x.movement_amount} ${context.loc.egp}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text.rich(
                              TextSpan(
                                text: x.reason,
                              ),
                              style: TextStyle(
                                decoration:
                                    (x.visit_id == null || x.visit_id!.isEmpty)
                                    ? TextDecoration.none
                                    : TextDecoration.underline,
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: switch (x.auto_add) {
                                true => const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                false => const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              },
                            ),
                          ),
                          DataCell(
                            Text(
                              x.added_by,
                              textAlign: TextAlign.center,
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
}
