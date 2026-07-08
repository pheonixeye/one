import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/profile_setup_item_ext.dart';
import 'package:one/models/doctor_items/pi_lab.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/providers/px_auth.dart';
import 'package:provider/provider.dart';

class PiLabCreateEditDialog extends StatefulWidget {
  const PiLabCreateEditDialog({super.key, this.piLab});
  final PiLab? piLab;

  @override
  State<PiLabCreateEditDialog> createState() => _PiLabCreateEditDialogState();
}

class _PiLabCreateEditDialogState extends State<PiLabCreateEditDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;

  ///[LAB]
  late final TextEditingController _labSpecialInstructionController;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(
      text: widget.piLab?.name_en ?? '',
    );
    _nameArController = TextEditingController(
      text: widget.piLab?.name_ar ?? '',
    );

    ///[LAB]
    _labSpecialInstructionController = TextEditingController(
      text: widget.piLab?.special_instructions ?? "",
    );
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();
    _labSpecialInstructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: widget.piLab == null
                ? Text.rich(
                    TextSpan(
                      text: context.loc.addNewItem,
                      children: [
                        TextSpan(text: '\n'),
                        TextSpan(
                          text:
                              '(${ProfileSetupItem.labs.pageTitleName(context)})',
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
                              '(${ProfileSetupItem.labs.pageTitleName(context)})',
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
                  controller: _labSpecialInstructionController,
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
                'id': widget.piLab?.id ?? '',
                'doc_id': context.read<PxAuth>().doc_id,
                'name_en': _nameEnController.text,
                'name_ar': _nameArController.text,
                'special_instructions': _labSpecialInstructionController.text,
              };

              final _piLab = PiLab.fromJson(_itemJson);

              Navigator.pop(context, _piLab);
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
