import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/profile_setup_item_ext.dart';
import 'package:one/models/doctor_items/doctor_rad_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class DoctorItemCreateEditDialog extends StatefulWidget {
  const DoctorItemCreateEditDialog({
    super.key,
    required this.type,
    required this.item,
  });
  final ProfileSetupItem type;
  final Map<String, dynamic>? item;
  @override
  State<DoctorItemCreateEditDialog> createState() =>
      _DoctorItemCreateEditDialogState();
}

class _DoctorItemCreateEditDialogState
    extends State<DoctorItemCreateEditDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;

  ///[DRUG]
  late final TextEditingController _drugConcentrationController;
  late final TextEditingController _drugUnitController;
  late final TextEditingController _drugFormController;
  late final TextEditingController _drugDefaultDosesController;

  ///[LAB]
  late final TextEditingController _labSpecialInstructionController;

  ///[RAD]
  late final TextEditingController _radSpecialInstructionController;
  RadiologyType? _radiologyTypeController;

  ///[PROCEDURE]
  late final TextEditingController _procedurePriceController;
  late final TextEditingController _procedureDiscountController;

  ///[SUPPLIES]
  late final TextEditingController _supplyUnitEnController;
  late final TextEditingController _supplyUnitArController;
  late final TextEditingController _supplyReorderQuantityController;
  late final TextEditingController _supplyTransferQuantityController;
  late final TextEditingController _supplyBuyingPriceController;
  late final TextEditingController _supplySellingPriceController;
  bool? _supplyNotifyOnOrderQuantityController;

  ///[DOCUMENTS]
  bool? _is_allowed_on_portal;

  ///[DRUG]
  ///final double concentration;
  ///final String unit;
  ///final String form;
  // ignore: unintended_html_in_doc_comment
  ///final List<String> default_doses;
  ///
  ///[LAB]
  ///final String special_instructions;
  ///
  ///[RAD]
  ///final String special_instructions;
  ///final RadiologyType type;
  ///
  ///[PROCEDURE]
  ///final int price;
  ///final int discount_percentage;
  ///
  ///[SUPPLIES]
  ///final String unit_en;
  ///final String unit_ar;
  ///final double reorder_quantity;
  ///final double buying_price;
  ///final double selling_price;
  ///final bool notify_on_reorder_quantity;
  ///[DOCUMENTS]
  ///final String name_en;
  ///final String name_ar;
  ///final bool is_allowed_on_portal;
  ///

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(
      text: widget.item?['name_en'] ?? '',
    );
    _nameArController = TextEditingController(
      text: widget.item?['name_ar'] ?? '',
    );

    ///[DRUGS]
    ///
    _drugConcentrationController = TextEditingController(
      text: widget.item?['concentration'] == null
          ? ''
          : '${widget.item?['concentration']}',
    );
    _drugUnitController = TextEditingController(
      text: widget.item?['unit'] ?? '',
    );
    _drugFormController = TextEditingController(
      text: widget.item?['form'] ?? '',
    );
    final List<String>? _defaultDoses = widget.item?['default_doses'];
    _drugDefaultDosesController = TextEditingController(
      text: _defaultDoses == null ? '' : _defaultDoses.join('-'),
    );

    ///[LABS]
    ///
    _labSpecialInstructionController = TextEditingController(
      text: widget.item?['special_instructions'] ?? '',
    );

    ///[RADS]
    ///
    _radSpecialInstructionController = TextEditingController(
      text: widget.item?['special_instructions'] ?? '',
    );
    _radiologyTypeController = RadiologyType.fromString(widget.item?['type']);

    ///[SUPPLIES]
    ///
    _supplyUnitEnController = TextEditingController(
      text: widget.item?['unit_en'] ?? '',
    );
    _supplyUnitArController = TextEditingController(
      text: widget.item?['unit_ar'] ?? '',
    );
    _supplyReorderQuantityController = TextEditingController(
      text: '${widget.item?['reorder_quantity'] ?? '0'}',
    );
    _supplyTransferQuantityController = TextEditingController(
      text: '${widget.item?['transfer_quantity'] ?? '0'}',
    );
    _supplyBuyingPriceController = TextEditingController(
      text: '${widget.item?['buying_price'] ?? '0'}',
    );
    _supplySellingPriceController = TextEditingController(
      text: '${widget.item?['selling_price'] ?? '0'}',
    );
    _supplyNotifyOnOrderQuantityController =
        widget.item?['notify_on_reorder_quantity'] ?? false;

    ///[PROCEDURES]
    ///
    _procedurePriceController = TextEditingController(
      text: '${widget.item?['price'] ?? '0'}',
    );
    _procedureDiscountController = TextEditingController(
      text: '${widget.item?['discount_percentage'] ?? '0'}',
    );

    ///[DOCUMENTS]
    ///
    _is_allowed_on_portal = widget.item?['is_allowed_on_portal'] ?? false;
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();

    _drugConcentrationController.dispose();
    _drugUnitController.dispose();
    _drugFormController.dispose();
    _drugDefaultDosesController.dispose();

    _labSpecialInstructionController.dispose();

    _radSpecialInstructionController.dispose();

    _procedurePriceController.dispose();
    _procedureDiscountController.dispose();

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
            child: widget.item == null
                ? Text.rich(
                    TextSpan(
                      text: context.loc.addNewItem,
                      children: [
                        TextSpan(text: '\n'),
                        TextSpan(
                          text: '(${widget.type.pageTitleName(context)})',
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
                          text: '(${widget.type.pageTitleName(context)})',
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
            ...switch (widget.type) {
              ProfileSetupItem.drugs => [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.drugConcentration),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: context.loc.drugConcentration,
                      ),
                      controller: _drugConcentrationController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.drugForm),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: context.loc.drugForm,
                      ),
                      controller: _drugFormController,
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.drugUnit),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: context.loc.drugUnit,
                      ),
                      controller: _drugUnitController,
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.drugDefaultDoses),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: context.loc.commaSeparatedValues,
                      ),
                      controller: _drugDefaultDosesController,
                      maxLines: 4,
                    ),
                  ),
                ),
              ],
              ProfileSetupItem.labs => [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.labSpecialInstructions),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: context.loc.labSpecialInstructions,
                      ),
                      controller: _labSpecialInstructionController,
                    ),
                  ),
                ),
              ],
              ProfileSetupItem.rads => [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.radiologyType),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<RadiologyType>(
                        items: [
                          ...RadiologyType.values.map((e) {
                            return DropdownMenuItem<RadiologyType>(
                              alignment: Alignment.center,
                              value: e,
                              child: Text(
                                context.read<PxLocale>().isEnglish
                                    ? e.type_en
                                    : e.type_ar,
                              ),
                            );
                          }),
                        ],
                        initialValue: _radiologyTypeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: context.loc.radSpecialInstructions,
                        ),
                        validator: (value) {
                          if (value == null) {
                            return '${context.loc.enter} ${context.loc.radiologyType}';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _radiologyTypeController = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.radSpecialInstructions),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: context.loc.radSpecialInstructions,
                      ),
                      controller: _radSpecialInstructionController,
                    ),
                  ),
                ),
              ],
              ProfileSetupItem.procedures => [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.price),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: context.loc.price,
                      ),
                      controller: _procedurePriceController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.discountPercentage),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: context.loc.discountPercentage,
                      ),
                      controller: _procedureDiscountController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
              ],
              ProfileSetupItem.supplies => [
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
              ProfileSetupItem.documents => [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.isAllowedOnPortal),
                  ),
                  trailing: Checkbox(
                    value: _is_allowed_on_portal,
                    onChanged: (val) {
                      setState(() {
                        _is_allowed_on_portal = val;
                      });
                    },
                  ),
                ),
              ],
            },
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
                'id': widget.item?['id'] ?? '',
                'doc_id': context.read<PxAuth>().doc_id,
                'name_en': _nameEnController.text,
                'name_ar': _nameArController.text,
                'item': widget.type.name.toString(),
                'concentration':
                    double.tryParse(_drugConcentrationController.text) ?? 0,
                'unit': _drugUnitController.text,
                'form': _drugFormController.text,
                'default_doses': _drugDefaultDosesController.text.split('-'),
                'special_instructions': switch (widget.type) {
                  ProfileSetupItem.labs =>
                    _labSpecialInstructionController.text,
                  ProfileSetupItem.rads =>
                    _radSpecialInstructionController.text,
                  _ => '',
                },
                'type': _radiologyTypeController?.db_value,
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
                'price': int.tryParse(_procedurePriceController.text),
                'discount_percentage': int.tryParse(
                  _procedureDiscountController.text,
                ),
                'is_allowed_on_portal': _is_allowed_on_portal,
              };
              Navigator.pop(context, _itemJson);
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
