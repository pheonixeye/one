import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/models/supplies/clinic_inventory_item.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/providers/px_clinic_inventory.dart';
import 'package:one/providers/px_doctor_profile_items.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:provider/provider.dart';

class SupplyItemTile extends StatefulWidget {
  const SupplyItemTile({super.key, required this.item, required this.index});
  final DoctorSupplyItem item;
  final int index;
  @override
  State<SupplyItemTile> createState() => _SupplyItemTileState();
}

class _SupplyItemTileState extends State<SupplyItemTile> {
  double quantity = 0;
  double delta_quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer4<
      PxDoctorProfileItems<DoctorSupplyItem>,
      PxVisitData,
      PxClinicInventory,
      PxLocale
    >(
      builder: (context, p, v, i, l, _) {
        while (v.result == null || p.data == null || i.result == null) {
          return const LinearProgressIndicator();
        }
        final _visit_data = (v.result as ApiDataResult<VisitData>).data;
        final _item_visit_quantity =
            _visit_data.supplies_data?[widget.item.id] as double? ?? 0;
        final _item_clinic_quantity =
            (i.result as ApiDataResult<List<ClinicInventoryItem>>).data
                .firstWhereOrNull((x) => x.supply_item.id == widget.item.id)
                ?.available_quantity ??
            0;
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SmBtn(child: Text('${widget.index + 1}')),
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: l.isEnglish
                          ? widget.item.name_en
                          : widget.item.name_ar,
                      children: [
                        TextSpan(text: '  ('),
                        WidgetSpan(
                          child: Tooltip(
                            message: context.loc.availableQuantity,
                            child: const Icon(Icons.warehouse, size: 18),
                          ),
                        ),
                        TextSpan(text: ' '),
                        TextSpan(text: '$_item_clinic_quantity)'),
                      ],
                    ),
                  ),
                ),
                Checkbox(
                  value: _visit_data.supplies.contains(widget.item),
                  onChanged: (value) async {
                    if (_item_clinic_quantity == 0) {
                      showIsnackbar(context.loc.noAvailableQuantity);
                      return;
                    }
                    await shellFunction(
                      context,
                      toExecute: () async {
                        if (_visit_data.supplies.contains(widget.item) ==
                            true) {
                          if (_visit_data.supplies_data?[widget.item.id] > 0) {
                            showIsnackbar(
                              context.loc.removeSupplyItemAmountFirst,
                            );
                            return;
                          }
                          await v.removeFromItemList(
                            widget.item.id,
                            ProfileSetupItem.supplies,
                          );
                        } else if (_visit_data.supplies.contains(widget.item) ==
                            false) {
                          await v.addToItemList(
                            widget.item.id,
                            ProfileSetupItem.supplies,
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          subtitle: (_visit_data.supplies.contains(widget.item))
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      spacing: 16,
                      children: [
                        SmBtn(
                          onPressed: () {
                            setState(() {
                              quantity =
                                  quantity - widget.item.transfer_quantity;
                            });
                          },
                          child: const Icon(Icons.remove),
                        ),
                        Text(
                          '($_item_visit_quantity) ==>> ($quantity) ${l.isEnglish ? widget.item.unit_en : widget.item.unit_ar}',
                        ),
                        SmBtn(
                          onPressed: () {
                            setState(() {
                              quantity =
                                  quantity + widget.item.transfer_quantity;
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () async {
                            delta_quantity = quantity - _item_visit_quantity;
                            if (delta_quantity == 0) {
                              return;
                            }
                            if (_item_clinic_quantity < delta_quantity) {
                              showIsnackbar(context.loc.noAvailableQuantity);
                              return;
                            }
                            await shellFunction(
                              context,
                              toExecute: () async {
                                //todo:
                                await v.updateSupplyItemQuantity(
                                  widget.item,
                                  quantity,
                                  delta_quantity, // +/-
                                );
                                await i.retry();
                              },
                            );
                          },
                          label: Text(context.loc.save),
                          icon: const Icon(Icons.save),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }
}
