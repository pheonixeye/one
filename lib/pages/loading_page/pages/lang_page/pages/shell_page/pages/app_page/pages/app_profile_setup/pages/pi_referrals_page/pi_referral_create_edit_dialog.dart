import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/profile_setup_item_ext.dart';
import 'package:one/models/doctor_items/pi_referral.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/providers/px_auth.dart';
import 'package:provider/provider.dart';

class PiReferralCreateEditDialog extends StatefulWidget {
  const PiReferralCreateEditDialog({super.key, this.piReferral});
  final PiReferral? piReferral;
  @override
  State<PiReferralCreateEditDialog> createState() =>
      _PiReferralCreateEditDialogState();
}

class _PiReferralCreateEditDialogState
    extends State<PiReferralCreateEditDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(
      text: widget.piReferral?.name_en ?? '',
    );
    _nameArController = TextEditingController(
      text: widget.piReferral?.name_ar ?? '',
    );
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: widget.piReferral == null
                ? Text.rich(
                    TextSpan(
                      text: context.loc.addNewItem,
                      children: [
                        TextSpan(text: '\n'),
                        TextSpan(
                          text:
                              '(${ProfileSetupItem.referrals.pageTitleName(context)})',
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
                              '(${ProfileSetupItem.referrals.pageTitleName(context)})',
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
                'id': widget.piReferral?.id ?? '',
                'doc_id': context.read<PxAuth>().doc_id,
                'name_en': _nameEnController.text,
                'name_ar': _nameArController.text,
              };

              final _piReferral = PiReferral.fromJson(_itemJson);

              Navigator.pop(context, _piReferral);
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
