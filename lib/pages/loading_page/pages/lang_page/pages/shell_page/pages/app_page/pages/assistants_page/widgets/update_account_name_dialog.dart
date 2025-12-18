import 'package:one/extensions/loc_ext.dart';
import 'package:flutter/material.dart';

class UpdateAccountNameDialog extends StatefulWidget {
  const UpdateAccountNameDialog({super.key});

  @override
  State<UpdateAccountNameDialog> createState() =>
      _UpdateAccountNameDialogState();
}

class _UpdateAccountNameDialogState extends State<UpdateAccountNameDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.editAccountName)),
          SizedBox(width: 10),
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
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(context.loc.arabicName),
              ),
              subtitle: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'محمد احمد'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.loc.enterArabicName;
                  }
                  return null;
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
              Navigator.pop(context, _nameController.text);
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
