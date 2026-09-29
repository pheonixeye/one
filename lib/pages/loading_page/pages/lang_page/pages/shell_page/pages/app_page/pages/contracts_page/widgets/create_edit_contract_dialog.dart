import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late final TextEditingController _patientPercentController;
  late final TextEditingController _consultationCostController;
  late final TextEditingController _followupCostController;
  String? _doc_id;

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
    _patientPercentController = TextEditingController(
      text: widget.contract?.patient_percent.toString() ?? '0.0',
    );
    _consultationCostController = TextEditingController(
      text: widget.contract?.consultation_cost.toString() ?? '0.0',
    );
    _followupCostController = TextEditingController(
      text: widget.contract?.followup_cost.toString() ?? '0.0',
    );

    _doc_id = widget.contract?.doc_id;
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();
    _patientPercentController.dispose();
    _consultationCostController.dispose();
    _followupCostController.dispose();
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
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isUserSuperAdmin)
              ExpansionTile(
                enabled: false,
                initiallyExpanded: true,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(context.loc.pickDoctor),
                ),
                showTrailingIcon: false,
                children: [
                  Consumer2<PxDoctor, PxLocale>(
                    builder: (context, d, l, _) {
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
                              child: SizedBox(
                                height: 80,
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
              ),
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
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.patientPercent),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.patientPercentHint,
                  ),
                  controller: _patientPercentController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterPatientPercent;
                    }
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.consultationCost),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.consultationCostHint,
                  ),
                  controller: _consultationCostController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterConsultationCost;
                    }
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.followupCost),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.followupCostHint,
                  ),
                  controller: _followupCostController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterFollowupCost;
                    }
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
              final _contract = Contract(
                id: widget.contract?.id ?? '',
                doc_id: _isUserSuperAdmin
                    ? _doc_id ?? ''
                    : context.read<PxAuth>().doc_id,
                name_en: _nameEnController.text,
                name_ar: _nameArController.text,
                is_active: widget.contract?.is_active ?? true,
                patient_percent: double.parse(_patientPercentController.text),
                consultation_cost: double.parse(
                  _consultationCostController.text,
                ),
                followup_cost: double.parse(_followupCostController.text),
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
