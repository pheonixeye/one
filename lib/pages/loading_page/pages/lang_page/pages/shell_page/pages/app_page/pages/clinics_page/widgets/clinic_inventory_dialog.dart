import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/supplies/clinic_inventory_item.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/add_new_inventory_item_dialog.dart';
import 'package:one/providers/px_clinic_inventory.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class ClinicInventoryDialog extends StatelessWidget {
  const ClinicInventoryDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.clinicInventory)),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      scrollable: false,
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Scaffold(
          body: Consumer2<PxClinicInventory, PxLocale>(
            builder: (context, i, l, _) {
              return Builder(
                builder: (context) {
                  while (i.result == null) {
                    return const CentralLoading();
                  }

                  while (i.result is ApiErrorResult) {
                    return CentralError(
                      code: (i.result as ApiErrorResult).errorCode,
                      toExecute: i.retry,
                    );
                  }

                  while (i.result != null &&
                      (i.result is ApiDataResult) &&
                      (i.result as ApiDataResult<List<ClinicInventoryItem>>)
                          .data
                          .isEmpty) {
                    return CentralNoItems(message: context.loc.noItemsFound);
                  }
                  final _items =
                      (i.result as ApiDataResult<List<ClinicInventoryItem>>)
                          .data;
                  return ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final _item = _items[index];
                      return Card.outlined(
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Row(
                              spacing: 16,
                              children: [
                                SmBtn(
                                  onPressed: null,
                                  child: Text('${index + 1}'),
                                ),
                                Text(
                                  l.isEnglish
                                      ? _item.supply_item.name_en
                                      : _item.supply_item.name_ar,
                                ),
                                Text(
                                  '(${_item.available_quantity}) ${l.isEnglish ? _item.supply_item.unit_en : _item.supply_item.unit_ar}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          floatingActionButton: Consumer<PxClinicInventory>(
            builder: (context, i, _) {
              while (i.result == null) {
                return const SizedBox();
              }
              final clinicInventoryItems =
                  (i.result as ApiDataResult<List<ClinicInventoryItem>>).data
                      .map((e) => e)
                      .toList();
              return SmBtn(
                tooltip: context.loc.addItemsWithCount,
                onPressed: () async {
                  final _inventoryItems =
                      await showDialog<List<ClinicInventoryItem>?>(
                        context: context,
                        builder: (context) {
                          return AddNewInventoryItemDialog(
                            clinic_id: i.api.clinic_id,
                            clinicInventoryItems: clinicInventoryItems,
                          );
                        },
                      );
                  if (_inventoryItems == null) {
                    return;
                  }
                  if (context.mounted) {
                    await shellFunction(
                      context,
                      toExecute: () async {
                        await i.addNewInventoryItems(_inventoryItems);
                      },
                    );
                  }
                },
                child: const Icon(Icons.add),
              );
            },
          ),
        ),
      ),
    );
  }
}
