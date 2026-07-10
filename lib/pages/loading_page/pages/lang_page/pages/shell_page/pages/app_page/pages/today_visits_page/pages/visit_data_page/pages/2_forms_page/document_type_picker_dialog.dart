import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/pi_document_type.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_documents.dart';
import 'package:one/widgets/central_error.dart';
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
  PiDocumentType? _document_type;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPiDocuments, PxLocale>(
      builder: (context, a, l, _) {
        while (a.documentTypes == null) {
          return const CentralLoading();
        }
        while (a.documentTypes is ApiErrorResult) {
          return CentralError(
            code: (a.documentTypes as ApiErrorResult).errorCode,
            toExecute: a.retry,
          );
        }
        final _data =
            (a.documentTypes as ApiDataResult<List<PiDocumentType>>).data;
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
                      subtitle: FormField<PiDocumentType?>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (field) {
                          return RadioGroup<PiDocumentType>(
                            groupValue: _document_type,
                            onChanged: (val) {
                              setState(() {
                                _document_type = val;
                              });
                            },
                            child: Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ..._data.map((e) {
                                  return RadioListTile<PiDocumentType>(
                                    title: Text(
                                      l.isEnglish ? e.name_en : e.name_ar,
                                    ),
                                    value: e,
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
                            ),
                          );
                        },
                        validator: (value) {
                          if (_document_type == null) {
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
                  Navigator.pop(context, _document_type);
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
