import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/reciept_info.dart';

class CreateEditRecieptInfoDialog extends StatefulWidget {
  const CreateEditRecieptInfoDialog({
    super.key,
    this.recieptInfo,
  });
  final RecieptInfo? recieptInfo;
  @override
  State<CreateEditRecieptInfoDialog> createState() =>
      _CreateEditRecieptInfoDialogState();
}

class _CreateEditRecieptInfoDialogState
    extends State<CreateEditRecieptInfoDialog> {
  late final formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _addressController;
  late final TextEditingController _footerController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.recieptInfo?.title ?? '',
    );
    _subtitleController = TextEditingController(
      text: widget.recieptInfo?.subtitle ?? '',
    );
    _addressController = TextEditingController(
      text: widget.recieptInfo?.address ?? '',
    );
    _footerController = TextEditingController(
      text: widget.recieptInfo?.footer ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.recieptInfo?.phone ?? '',
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _addressController.dispose();
    _footerController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.recieptInfo == null
                  ? context.loc.addNewRecieptInfo
                  : context.loc.editRecieptInfo,
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
      scrollable: true,
      content: Form(
        key: formKey,
        child: Column(
          children: [
            ListTile(
              title: Text(context.loc.recieptTitle),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: context.loc.enterRecieptTitle,
                      ),
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc.enterValidTitleForReciept;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(context.loc.recieptSubtitle),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: context.loc.enterRecieptSubtitle,
                      ),
                      controller: _subtitleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc.enterValidSubtitleForReciept;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(context.loc.recieptAddress),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: context.loc.enterRecieptAddress,
                      ),
                      controller: _addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc.enterValidAddressForReciept;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(context.loc.recieptFooter),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: context.loc.enterRecieptFooter,
                      ),
                      controller: _footerController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc.enterValidFooterForReciept;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(context.loc.recieptPhone),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: context.loc.enterRecieptPhone,
                      ),
                      controller: _phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc.enterValidPhoneForReciept;
                        }
                        if (value.length != 11) {
                          return context.loc.enterValidPhoneNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
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
              final _info = RecieptInfo(
                id: widget.recieptInfo?.id ?? '',
                title: _titleController.text,
                subtitle: _subtitleController.text,
                address: _addressController.text,
                footer: _footerController.text,
                phone: _phoneController.text,
              );
              Navigator.pop(context, _info);
            }
          },
          label: Text(context.loc.confirm),
          icon: Icon(
            Icons.check,
            color: Colors.green.shade100,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, null);
          },
          label: Text(context.loc.cancel),
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
