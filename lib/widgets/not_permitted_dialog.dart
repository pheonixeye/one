import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/providers/px_locale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotPermittedDialog extends StatelessWidget {
  const NotPermittedDialog({super.key, required this.permission});
  final AppPermission permission;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.unAuthorized)),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PxLocale>(
          builder: (context, l, _) {
            return Text(
              '${context.loc.accountNotAuthorizedToPerformAction}\n(-${l.isEnglish ? permission.name_en : permission.name_ar}-)',
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, null);
          },
          label: Text(context.loc.confirm),
          icon: Icon(Icons.check, color: Colors.green.shade100),
        ),
      ],
    );
  }
}
