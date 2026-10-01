import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/contract.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class CreateEditContractDialog extends StatefulWidget {
  const CreateEditContractDialog({super.key, this.contract});
  final Contract? contract;

  @override
  State<CreateEditContractDialog> createState() =>
      _CreateEditContractDialogState();
}

class _CreateEditContractDialogState extends State<CreateEditContractDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  ContractType? _contractType;
  String? _doc_id;
  ContractData? _contractData;

  late final _isUserSuperAdmin = context
      .read<PxAuth>()
      .isLoggedInUserSuperAdmin();

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(
      text: widget.contract?.name_en ?? '',
    );
    _nameArController = TextEditingController(
      text: widget.contract?.name_ar ?? '',
    );

    _contractType = widget.contract?.contract_type;

    _doc_id = widget.contract?.doc_id;

    _contractData = widget.contract?.contract_data;
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
            child: widget.contract == null
                ? Text(context.loc.addNewContract)
                : Text(context.loc.editContract),
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
      scrollable: true,
      content: Consumer<PxLocale>(
        builder: (context, l, _) {
          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.englishContractName),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'eg: Axa, Bupa...',
                      ),
                      controller: _nameEnController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc.enterEnglishContractName;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.arabicContractName),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'مثال: اكسا - بوبا...',
                      ),
                      controller: _nameArController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc.enterArabicContractName;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                if (_isUserSuperAdmin) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      context.loc.pickDoctor,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).listTileTheme.titleTextStyle,
                    ),
                  ),
                  Consumer<PxDoctor>(
                    builder: (context, d, _) {
                      while (d.allDoctors == null) {
                        return const SizedBox(
                          height: 8,
                          child: LinearProgressIndicator(),
                        );
                      }
                      final _doctors = d.allDoctors;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 80,
                                ),
                                child: DropdownButtonFormField<String?>(
                                  alignment: Alignment.center,
                                  initialValue: _doc_id,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  isExpanded: true,
                                  items: [
                                    if (_doctors != null)
                                      ..._doctors.map((e) {
                                        return DropdownMenuItem<String?>(
                                          value: e.id,
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  text: l.isEnglish
                                                      ? e.name_en
                                                      : e.name_ar,
                                                  children: [
                                                    TextSpan(text: ' - '),
                                                    TextSpan(
                                                      text: l.isEnglish
                                                          ? e.spec_en
                                                          : e.spec_ar,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _doc_id = value;
                                      });
                                    }
                                  },
                                  validator: _isUserSuperAdmin
                                      ? (value) {
                                          if (value == null || value.isEmpty) {
                                            return context
                                                .loc
                                                .enterEnglishContractName;
                                          }
                                          return null;
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.loc.selectContractType,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).listTileTheme.titleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 80,
                          ),
                          child: DropdownButtonFormField<ContractType?>(
                            alignment: Alignment.center,
                            initialValue: _contractType,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            items: [
                              ...ContractType.values.map((e) {
                                return DropdownMenuItem<ContractType?>(
                                  value: e,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text: l.isEnglish
                                              ? e.name_en
                                              : e.name_ar,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _contractData = null;
                                  _contractType = value;
                                  _contractData = ContractData.fromContractType(
                                    type: value,
                                    map: {},
                                  );
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return context.loc.selectContractType;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_contractType != null) ...[
                  Card.outlined(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            context.loc.contractInformation,
                            textAlign: TextAlign.start,
                            style: Theme.of(
                              context,
                            ).listTileTheme.titleTextStyle,
                          ),
                        ),

                        if (_contractData != null)
                          ..._contractData!.forWidgets().entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text.rich(
                                TextSpan(
                                  text: l.isEnglish
                                      ? entry.value.en
                                      : entry.value.ar,
                                  style: Theme.of(
                                    context,
                                  ).listTileTheme.titleTextStyle,
                                  children: [
                                    TextSpan(text: '\n'),
                                    WidgetSpan(
                                      child: switch (entry.value.type) {
                                        const (num) => ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 300,
                                            maxHeight: 80,
                                          ),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            initialValue:
                                                _contractData
                                                        ?.toJson()[entry.key] ==
                                                    null
                                                ? '0'
                                                : _contractData
                                                      ?.toJson()[entry.key]
                                                      .toString(),
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                setState(() {
                                                  _contractData = _contractData
                                                      ?.copyWithOneParameter(
                                                        key: entry.key,
                                                        value: num.parse(value),
                                                      );
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        const (bool) => ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 300,
                                            maxHeight: 80,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Checkbox(
                                                tristate: true,
                                                value: _contractData
                                                    ?.toJson()[entry.key],
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      _contractData = _contractData
                                                          ?.copyWithOneParameter(
                                                            key: entry.key,
                                                            value: value,
                                                          );
                                                    });
                                                  }
                                                },
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                        _ => const SizedBox(),
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final _contract = Contract(
                id: widget.contract?.id ?? '',
                doc_id: _isUserSuperAdmin
                    ? _doc_id ?? ''
                    : context.read<PxAuth>().doc_id,
                name_en: _nameEnController.text,
                name_ar: _nameArController.text,
                is_active: widget.contract?.is_active ?? true,
                contract_type: _contractType!,
                contract_data: ContractData.fromContractType(
                  type: _contractType!,
                  map: _contractData?.toJson() ?? {},
                ),
              );
              Navigator.pop(context, _contract);
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
