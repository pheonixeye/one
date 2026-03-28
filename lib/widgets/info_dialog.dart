import 'package:flutter/material.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text('')),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, false);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Image.asset(AppAssets.featureImage(2), width: 150, height: 150),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, true);
          },
          label: Text(context.loc.confirm),
          icon: Icon(Icons.check, color: Colors.green.shade100),
        ),
      ],
    );
  }
}
