import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/models/supplies/clinic_inventory_item.dart';
import 'package:one/providers/px_doctor_profile_items.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class AddNewInventoryItemDialog extends StatefulWidget {
  const AddNewInventoryItemDialog({
    super.key,
    required this.clinic_id,
    this.clinicInventoryItems,
  });
  final String clinic_id;
  final List<ClinicInventoryItem>? clinicInventoryItems;
  @override
  State<AddNewInventoryItemDialog> createState() =>
      _AddNewInventoryItemDialogState();
}

class _AddNewInventoryItemDialogState extends State<AddNewInventoryItemDialog> {
  final formKey = GlobalKey<FormState>();
  Map<String, MapEntry<String, double>>? _state;
  Map<String, String>? _idKeeper;
  @override
  void initState() {
    super.initState();
    _state = Map.fromEntries(
      widget.clinicInventoryItems?.map(
            (x) => MapEntry(
              x.supply_item.id,
              MapEntry(x.id, x.available_quantity),
            ),
          ) ??
          {},
    );
    _idKeeper = Map.fromEntries(
      widget.clinicInventoryItems?.map(
            (x) => MapEntry(x.supply_item.id, x.id),
          ) ??
          {},
    );
  }

  String gen10Id({int length = 15}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    return List.generate(
      length,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxDoctorProfileItems<DoctorSupplyItem>, PxLocale>(
      builder: (context, p, l, _) {
        while (p.data == null) {
          return const CentralLoading();
        }
        while ((p.data as ApiDataResult<List<DoctorSupplyItem>>).data.isEmpty) {
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
            content: CentralNoItems(message: context.loc.noItemsFound),
          );
        }
        final _items = (p.data as ApiDataResult<List<DoctorSupplyItem>>).data;
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
          content: Form(
            key: formKey,
            child: SizedBox(
              width: context.visitItemDialogWidth,
              height: context.visitItemDialogWidth,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final _item = _items[index];

                  return Card.outlined(
                    elevation: 6,
                    child: ListTile(
                      title: Row(
                        spacing: 16,
                        children: [
                          Checkbox(
                            value: _state?.keys.contains(_item.id),
                            onChanged: (val) {
                              if (_state?.keys.contains(_item.id) == true) {
                                // setState(() {
                                //   _state = _state
                                //     ?..removeWhere((k, v) => k == _item.id);
                                // });
                                //HACK: Find a better way
                                return;
                              } else {
                                setState(() {
                                  String _new_id = gen10Id();
                                  _idKeeper?[_item.id] = _new_id;
                                  _state?[_item.id] = MapEntry(
                                    _state?[_item.id]?.key ??
                                        _idKeeper?[_item.id] ??
                                        _new_id,
                                    0,
                                  );
                                });
                              }
                            },
                          ),
                          Text(l.isEnglish ? _item.name_en : _item.name_ar),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            if (_state?[_item.id] != null)
                              Expanded(
                                child: TextFormField(
                                  initialValue: _state?[_item.id]?.value
                                      .toString(),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: context
                                        .loc
                                        .enterInitialItemAvailableQuantity,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _state?[_item.id] = MapEntry(
                                        _state?[_item.id]?.key ??
                                            _idKeeper![_item.id]!,
                                        double.tryParse(value) ?? 0,
                                      );
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final _clinicInventoryItems = _state?.entries.map((x) {
                    return ClinicInventoryItem(
                      id: x.value.key,
                      clinic_id: widget.clinic_id,
                      supply_item: _items.firstWhere((e) => e.id == x.key),
                      available_quantity: x.value.value,
                    );
                  }).toList();
                  if (_clinicInventoryItems != null) {
                    Navigator.pop(context, _clinicInventoryItems);
                  }
                }
              },
              label: Text(context.loc.confirm),
              icon: Icon(Icons.check, color: Colors.green.shade100),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: Text(context.loc.cancel),
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
