import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/profile_setup_item_ext.dart';
import 'package:one/models/doctor_items/pi_rads.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class PiRadCreateEditDialog extends StatefulWidget {
  const PiRadCreateEditDialog({super.key, this.piRad});
  final PiRad? piRad;

  @override
  State<PiRadCreateEditDialog> createState() => _PiRadCreateEditDialogState();
}

class _PiRadCreateEditDialogState extends State<PiRadCreateEditDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;

  ///[RAD]
  late final TextEditingController _radSpecialInstructionController;
  RadiologyType? _radiologyTypeController;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(
      text: widget.piRad?.name_en ?? '',
    );
    _nameArController = TextEditingController(
      text: widget.piRad?.name_ar ?? '',
    );

    ///[RAD]
    _radSpecialInstructionController = TextEditingController(
      text: widget.piRad?.special_instructions ?? "",
    );

    _radiologyTypeController = widget.piRad?.type;
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();
    _radSpecialInstructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: widget.piRad == null
                ? Text.rich(
                    TextSpan(
                      text: context.loc.addNewItem,
                      children: [
                        TextSpan(text: '\n'),
                        TextSpan(
                          text:
                              '(${ProfileSetupItem.rads.pageTitleName(context)})',
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
                              '(${ProfileSetupItem.rads.pageTitleName(context)})',
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
                child: Text(context.loc.radiologyType),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<PxLocale>(
                  builder: (context, l, _) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<RadiologyType>(
                        items: [
                          ...RadiologyType.values.map((e) {
                            return DropdownMenuItem<RadiologyType>(
                              alignment: Alignment.center,
                              value: e,
                              child: Text(
                                l.isEnglish ? e.type_en : e.type_ar,
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
                    );
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.labSpecialInstructions),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.labSpecialInstructions,
                  ),
                  controller: _radSpecialInstructionController,
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
                'id': widget.piRad?.id ?? '',
                'doc_id': context.read<PxAuth>().doc_id,
                'name_en': _nameEnController.text,
                'name_ar': _nameArController.text,
                'special_instructions': _radSpecialInstructionController.text,
                'type': _radiologyTypeController?.db_value,
              };

              final _piRad = PiRad.fromJson(_itemJson);

              Navigator.pop(context, _piRad);
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
