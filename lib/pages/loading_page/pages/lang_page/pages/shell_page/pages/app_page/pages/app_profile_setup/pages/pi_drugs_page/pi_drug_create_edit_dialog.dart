import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/profile_setup_item_ext.dart';
import 'package:one/models/doctor_items/pi_drug.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/providers/px_auth.dart';
import 'package:provider/provider.dart';

class PiDrugCreateEditDialog extends StatefulWidget {
  const PiDrugCreateEditDialog({
    super.key,
    required this.piDrug,
  });
  final PiDrug? piDrug;
  @override
  State<PiDrugCreateEditDialog> createState() => _PiDrugCreateEditDialogState();
}

class _PiDrugCreateEditDialogState extends State<PiDrugCreateEditDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;

  ///[DRUG]
  late final TextEditingController _drugConcentrationController;
  late final TextEditingController _drugUnitController;
  late final TextEditingController _drugFormController;
  late final TextEditingController _drugDefaultDosesController;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(
      text: widget.piDrug?.name_en ?? '',
    );
    _nameArController = TextEditingController(
      text: widget.piDrug?.name_ar ?? '',
    );

    ///[DRUGS]
    ///
    _drugConcentrationController = TextEditingController(
      text: widget.piDrug?.concentration == null
          ? ''
          : '${widget.piDrug?.concentration}',
    );
    _drugUnitController = TextEditingController(
      text: widget.piDrug?.unit ?? '',
    );
    _drugFormController = TextEditingController(
      text: widget.piDrug?.form ?? '',
    );
    final List<String>? _defaultDoses = widget.piDrug?.default_doses;
    _drugDefaultDosesController = TextEditingController(
      text: _defaultDoses == null ? '' : _defaultDoses.join('-'),
    );
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();

    _drugConcentrationController.dispose();
    _drugUnitController.dispose();
    _drugFormController.dispose();
    _drugDefaultDosesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: widget.piDrug == null
                ? Text.rich(
                    TextSpan(
                      text: context.loc.addNewItem,
                      children: [
                        TextSpan(text: '\n'),
                        TextSpan(
                          text:
                              '(${ProfileSetupItem.drugs.pageTitleName(context)})',
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
                              '(${ProfileSetupItem.drugs.pageTitleName(context)})',
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
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final _itemJson = {
                'id': widget.piDrug?.id ?? '',
                'doc_id': context.read<PxAuth>().doc_id,
                'name_en': _nameEnController.text,
                'name_ar': _nameArController.text,
                'concentration':
                    double.tryParse(_drugConcentrationController.text) ?? 0,
                'unit': _drugUnitController.text,
                'form': _drugFormController.text,
                'default_doses': _drugDefaultDosesController.text.split('-'),
              };

              final _piDrug = PiDrug.fromJson(_itemJson);

              Navigator.pop(context, _piDrug);
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
