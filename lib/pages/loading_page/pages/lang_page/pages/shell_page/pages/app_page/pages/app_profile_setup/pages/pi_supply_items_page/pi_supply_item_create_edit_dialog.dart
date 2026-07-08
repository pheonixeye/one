import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/profile_setup_item_ext.dart';
import 'package:one/models/doctor_items/pi_supply_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/providers/px_auth.dart';
import 'package:provider/provider.dart';

class PiSupplyItemCreateEditDialog extends StatefulWidget {
  const PiSupplyItemCreateEditDialog({super.key, this.piSupplyItem});
  final PiSupplyItem? piSupplyItem;
  @override
  State<PiSupplyItemCreateEditDialog> createState() =>
      _PiSupplyItemCreateEditDialogState();
}

class _PiSupplyItemCreateEditDialogState
    extends State<PiSupplyItemCreateEditDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;

  ///[SUPPLIES]
  late final TextEditingController _supplyUnitEnController;
  late final TextEditingController _supplyUnitArController;
  late final TextEditingController _supplyReorderQuantityController;
  late final TextEditingController _supplyTransferQuantityController;
  late final TextEditingController _supplyBuyingPriceController;
  late final TextEditingController _supplySellingPriceController;
  bool? _supplyNotifyOnOrderQuantityController;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(
      text: widget.piSupplyItem?.name_en ?? '',
    );
    _nameArController = TextEditingController(
      text: widget.piSupplyItem?.name_ar ?? '',
    );

    _supplyUnitEnController = TextEditingController(
      text: widget.piSupplyItem?.unit_en ?? '',
    );
    _supplyUnitArController = TextEditingController(
      text: widget.piSupplyItem?.unit_ar ?? '',
    );
    _supplyReorderQuantityController = TextEditingController(
      text: '${widget.piSupplyItem?.reorder_quantity ?? '0'}',
    );
    _supplyTransferQuantityController = TextEditingController(
      text: '${widget.piSupplyItem?.transfer_quantity ?? '0'}',
    );
    _supplyBuyingPriceController = TextEditingController(
      text: '${widget.piSupplyItem?.buying_price ?? '0'}',
    );
    _supplySellingPriceController = TextEditingController(
      text: '${widget.piSupplyItem?.selling_price ?? '0'}',
    );
    _supplyNotifyOnOrderQuantityController =
        widget.piSupplyItem?.notify_on_reorder_quantity ?? false;
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();

    _supplyUnitEnController.dispose();
    _supplyUnitArController.dispose();
    _supplyReorderQuantityController.dispose();
    _supplyTransferQuantityController.dispose();
    _supplyBuyingPriceController.dispose();
    _supplySellingPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: widget.piSupplyItem == null
                ? Text.rich(
                    TextSpan(
                      text: context.loc.addNewItem,
                      children: [
                        TextSpan(text: '\n'),
                        TextSpan(
                          text:
                              '(${ProfileSetupItem.supplies.pageTitleName(context)})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text.rich(
                    TextSpan(
                      text: context.loc.updateItem,
                      children: [
                        TextSpan(text: '\n'),
                        TextSpan(
                          text:
                              '(${ProfileSetupItem.supplies.pageTitleName(context)})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      scrollable: true,
      contentPadding: const EdgeInsets.all(8),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.englishItemName),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.englishItemName,
                  ),
                  controller: _nameEnController,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${context.loc.enter} ${context.loc.englishItemName}';
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.arabicItemName),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.arabicItemName,
                  ),
                  controller: _nameArController,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${context.loc.enter} ${context.loc.arabicItemName}';
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.supplyItemUnitEn),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.supplyItemUnitEn,
                  ),
                  controller: _supplyUnitEnController,
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.supplyItemUnitAr),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.supplyItemUnitAr,
                  ),
                  controller: _supplyUnitArController,
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.reorderQuantity),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.reorderQuantity,
                  ),
                  controller: _supplyReorderQuantityController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.transferQuantity),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.transferQuantity,
                  ),
                  controller: _supplyTransferQuantityController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.buyingPrice),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.buyingPrice,
                  ),
                  controller: _supplyBuyingPriceController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.sellingPrice),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.sellingPrice,
                  ),
                  controller: _supplySellingPriceController,
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.notifyOnReorder),
              ),
              trailing: Checkbox(
                value: _supplyNotifyOnOrderQuantityController,
                onChanged: (val) {
                  setState(() {
                    _supplyNotifyOnOrderQuantityController = val;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final _itemJson = {
                'id': widget.piSupplyItem?.id ?? '',
                'doc_id': context.read<PxAuth>().doc_id,
                'name_en': _nameEnController.text,
                'name_ar': _nameArController.text,
                'unit_en': _supplyUnitEnController.text,
                'unit_ar': _supplyUnitArController.text,
                'reorder_quantity': double.tryParse(
                  _supplyReorderQuantityController.text,
                ),
                'transfer_quantity': double.tryParse(
                  _supplyTransferQuantityController.text,
                ),
                'buying_price': double.tryParse(
                  _supplyBuyingPriceController.text,
                ),
                'selling_price': double.tryParse(
                  _supplySellingPriceController.text,
                ),
                'notify_on_reorder_quantity':
                    _supplyNotifyOnOrderQuantityController,
              };

              final _piSupplyItem = PiSupplyItem.fromJson(_itemJson);

              Navigator.pop(context, _piSupplyItem);
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
  }
}
