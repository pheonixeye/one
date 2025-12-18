import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/pc_form.dart';
import 'package:one/providers/px_forms.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class FormPickerDialog extends StatefulWidget {
  const FormPickerDialog({super.key});

  @override
  State<FormPickerDialog> createState() => _FormPickerDialogState();
}

class _FormPickerDialogState extends State<FormPickerDialog> {
  PcForm? _form;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxForms, PxLocale>(
      builder: (context, f, l, _) {
        while (f.result == null) {
          return const CentralLoading();
        }
        final _items = (f.result as ApiDataResult<List<PcForm>>).data;
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.addNewForm,
                    style: TextStyle(fontWeight: FontWeight.bold),
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
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: context.visitItemDialogWidth,
            height: context.visitItemDialogHeight,
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final _item = _items[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card.outlined(
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RadioListTile<PcForm>(
                        title: Text(
                          l.isEnglish ? _item.name_en : _item.name_ar,
                        ),
                        value: _item,
                        groupValue: _form,
                        onChanged: (value) {
                          if (value != null) {
                            Navigator.pop(context, value);
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
