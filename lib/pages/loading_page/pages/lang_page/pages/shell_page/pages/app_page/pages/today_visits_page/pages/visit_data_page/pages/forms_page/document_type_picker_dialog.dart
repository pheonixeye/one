import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentTypePickerDialog extends StatefulWidget {
  const DocumentTypePickerDialog({super.key});

  @override
  State<DocumentTypePickerDialog> createState() =>
      _DocumentTypePickerDialogState();
}

class _DocumentTypePickerDialogState extends State<DocumentTypePickerDialog> {
  String? _document_type_id;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxAppConstants, PxLocale>(
      builder: (context, a, l, _) {
        while (a.constants == null) {
          return const CentralLoading();
        }
        final _data = a.constants?.documentType;
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text(context.loc.pickDocumentType)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton.outlined(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          scrollable: true,
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.titleHeight,
                      leading: const SmBtn(),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.pickDocumentType),
                      ),
                      subtitle: FormField<String?>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (field) {
                          return Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_data != null)
                                ..._data.map((e) {
                                  return RadioListTile(
                                    title: Text(
                                      l.isEnglish ? e.name_en : e.name_ar,
                                    ),
                                    value: e.id,
                                    groupValue: _document_type_id,
                                    onChanged: (val) {
                                      setState(() {
                                        _document_type_id = val;
                                      });
                                    },
                                  );
                                }),
                              if (field.hasError)
                                Text(
                                  field.errorText ?? '',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          );
                        },
                        validator: (value) {
                          if (_document_type_id == null ||
                              _document_type_id!.isEmpty) {
                            return context.loc.pickDocumentType;
                          }
                          return null;
                        },
                        errorBuilder: (context, errorText) {
                          return Text(errorText);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, _document_type_id);
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
      },
    );
  }
}
