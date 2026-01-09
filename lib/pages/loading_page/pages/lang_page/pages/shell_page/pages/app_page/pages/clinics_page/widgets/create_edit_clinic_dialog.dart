import 'package:one/providers/px_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/clinic/clinic.dart';

class CreateEditClinicDialog extends StatefulWidget {
  const CreateEditClinicDialog({super.key, this.clinic});
  final Clinic? clinic;
  @override
  State<CreateEditClinicDialog> createState() => _CreateEditClinicDialogState();
}

class _CreateEditClinicDialogState extends State<CreateEditClinicDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _phoneController;
  late final TextEditingController _consultationFeesController;
  late final TextEditingController _followupFeesController;
  late final TextEditingController _procedureFeesController;
  late final TextEditingController _followupDurationController;
  List<String> _doc_id = [];

  bool? _is_main;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(
      text: widget.clinic?.name_en ?? '',
    );
    _nameArController = TextEditingController(
      text: widget.clinic?.name_ar ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.clinic?.phone_number ?? '',
    );
    _consultationFeesController = TextEditingController(
      text: widget.clinic?.consultation_fees.toString() ?? '',
    );
    _followupFeesController = TextEditingController(
      text: widget.clinic?.followup_fees.toString() ?? '',
    );
    _procedureFeesController = TextEditingController(
      text: widget.clinic?.procedure_fees.toString() ?? '',
    );
    _followupDurationController = TextEditingController(
      text: widget.clinic?.followup_duration.toString() ?? '',
    );
    _is_main = widget.clinic?.is_main ?? false;
    _doc_id = widget.clinic?.doc_id ?? [];
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();
    _phoneController.dispose();
    _consultationFeesController.dispose();
    _followupFeesController.dispose();
    _procedureFeesController.dispose();
    _followupDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: widget.clinic == null
                ? Text(context.loc.addNewClinic)
                : Text(context.loc.editClinic),
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
      contentPadding: const EdgeInsets.all(8),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.englishClinicName),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.englishClinicName,
                  ),
                  controller: _nameEnController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterEnglishClinicName;
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.arabicClinicName),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.arabicClinicName,
                  ),
                  controller: _nameArController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterArabicClinicName;
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.phone),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.phone,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterPhoneNumber;
                    }
                    if (value.length != 11) {
                      return context.loc.enterValidPhoneNumber;
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.consultationFees),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.consultationFees,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _consultationFeesController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterConsultationFees;
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.followupFees),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.followupFees,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _followupFeesController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterFollowupFees;
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.procedureFees),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.procedureFees,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _procedureFeesController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterProcedureFees;
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.followupDuration),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.followupDuration,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _followupDurationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc.enterFollowupDuration;
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.isMain),
              ),
              trailing: Checkbox(
                value: _is_main,
                onChanged: (val) {
                  setState(() {
                    _is_main = val;
                  });
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
              final _clinic = Clinic(
                id: widget.clinic?.id ?? '',
                name_en: _nameEnController.text,
                name_ar: _nameArController.text,
                doc_id: _doc_id.isEmpty
                    ? [PxAuth.doc_id_static_getter]
                    : _doc_id,
                phone_number: _phoneController.text,
                consultation_fees: int.parse(_consultationFeesController.text),
                followup_fees: int.parse(_followupFeesController.text),
                procedure_fees: int.parse(_procedureFeesController.text),
                followup_duration: int.parse(_followupDurationController.text),
                is_main: _is_main!,
                is_active: true,
                prescription_file: '',
                clinic_schedule: widget.clinic?.clinic_schedule ?? [],
              );
              Navigator.pop(context, _clinic);
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
