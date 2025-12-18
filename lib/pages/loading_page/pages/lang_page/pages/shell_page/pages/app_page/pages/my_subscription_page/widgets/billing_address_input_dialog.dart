import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/contains_arabic.dart';

class BillingAddressInputDialog extends StatefulWidget {
  const BillingAddressInputDialog({super.key});

  @override
  State<BillingAddressInputDialog> createState() =>
      _BillingAddressInputDialogState();
}

class _BillingAddressInputDialogState extends State<BillingAddressInputDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _billingAddressController;

  @override
  void initState() {
    super.initState();
    _billingAddressController = TextEditingController();
  }

  @override
  void dispose() {
    _billingAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.billingAddress)),
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
                child: Text(context.loc.billingAddress),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.billingAddress,
                  ),
                  controller: _billingAddressController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterBillingAddress;
                    }
                    if (!containsArabic(value)) {
                      return context.loc.enterBillingAddressInArabic;
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
              Navigator.pop(context, _billingAddressController.text);
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
