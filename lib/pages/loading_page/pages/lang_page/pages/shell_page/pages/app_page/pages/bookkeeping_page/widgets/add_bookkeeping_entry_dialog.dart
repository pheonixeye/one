import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/bookkeeping/bookkeeping_direction.dart';
import 'package:one/models/bookkeeping/bookkeeping_item_dto.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class AddBookkeepingEntryDialog extends StatefulWidget {
  const AddBookkeepingEntryDialog({super.key});

  @override
  State<AddBookkeepingEntryDialog> createState() =>
      _AddBookkeepingEntryDialogState();
}

class _AddBookkeepingEntryDialogState extends State<AddBookkeepingEntryDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _operationController;
  late final TextEditingController _amountController;
  BookkeepingDirection? _type;

  @override
  void initState() {
    super.initState();
    _operationController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _operationController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade50,
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.loc.addBookkeepingEntry,
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
      scrollable: true,
      content: Form(
        key: formKey,
        child: Column(
          spacing: 8,
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.operation),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: context.loc.operationName,
                        ),
                        controller: _operationController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '${context.loc.enter} ${context.loc.operationName}';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.amount),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: context.loc.amountInPounds,
                        ),
                        controller: _amountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '${context.loc.enter} ${context.loc.amountInPounds}';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.bkType),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<PxLocale>(
                  builder: (context, l, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<BookkeepingDirection>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: context.loc.bkType,
                              ),
                              isExpanded: true,
                              initialValue: _type,
                              alignment: Alignment.center,
                              items: [
                                ...BookkeepingDirection.values.map((e) {
                                  return DropdownMenuItem(
                                    alignment: Alignment.center,
                                    value: e,
                                    enabled: e != BookkeepingDirection.NONE,
                                    child: Text(l.isEnglish ? e.en : e.ar),
                                  );
                                }),
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return '${context.loc.enter} ${context.loc.bkType}';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _type = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    );
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
              final _amount = switch (_type) {
                null => 0,
                BookkeepingDirection.IN => double.parse(
                  _amountController.text.isEmpty ? '0' : _amountController.text,
                ),
                BookkeepingDirection.OUT => -double.parse(
                  _amountController.text.isEmpty ? '0' : _amountController.text,
                ),
                BookkeepingDirection.NONE => 0,
              };
              final _bkDto = BookkeepingItemDto(
                id: '',
                item_name: _operationController.text,
                item_id: '',
                collection_id: '',
                added_by_id: PxAuth.doc_id_static_getter,
                updated_by_id: '',
                amount: _amount.toDouble(),
                type: _type?.value ?? BookkeepingDirection.NONE.value,
                update_reason: '',
                auto_add: false,
              );
              Navigator.pop(context, _bkDto);
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
