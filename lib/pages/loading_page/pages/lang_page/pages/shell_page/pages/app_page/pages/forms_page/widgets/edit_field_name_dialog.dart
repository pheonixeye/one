import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';

class EditFieldNameDialog extends StatefulWidget {
  const EditFieldNameDialog({super.key, required this.fieldName});
  final String fieldName;

  @override
  State<EditFieldNameDialog> createState() => _EditFieldNameDialogState();
}

class _EditFieldNameDialogState extends State<EditFieldNameDialog> {
  late final TextEditingController _controller;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.fieldName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.editFieldName)),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.fieldName),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.fieldNameHint,
                  ),
                  controller: _controller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.loc.enterFieldName;
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
              Navigator.pop(context, _controller.text);
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
