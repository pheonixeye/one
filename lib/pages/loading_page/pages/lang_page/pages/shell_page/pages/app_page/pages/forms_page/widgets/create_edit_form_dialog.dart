import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/pc_form.dart';

class CreateEditFormDialog extends StatefulWidget {
  const CreateEditFormDialog({super.key, this.form});
  final PcForm? form;

  @override
  State<CreateEditFormDialog> createState() => _CreateEditFormDialogState();
}

class _CreateEditFormDialogState extends State<CreateEditFormDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(text: widget.form?.name_en ?? '');
    _nameArController = TextEditingController(text: widget.form?.name_ar ?? '');
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
            child: widget.form == null
                ? Text(context.loc.addNewForm)
                : Text(context.loc.editForm),
          ),
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
                child: Text(context.loc.englishFormName),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'eg: Sheet Form, Past History Form...',
                  ),
                  controller: _nameEnController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterEnglishFormName;
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.arabicFormName),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        'مثال: نموذج بيانات الزيارة - نموذج التاريخ المرضي...',
                  ),
                  controller: _nameArController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterArabicFormName;
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
              final _form = PcForm(
                id: widget.form?.id ?? '',
                name_en: _nameEnController.text,
                name_ar: _nameArController.text,
                form_fields: widget.form?.form_fields ?? const [],
              );
              Navigator.pop(context, _form);
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
