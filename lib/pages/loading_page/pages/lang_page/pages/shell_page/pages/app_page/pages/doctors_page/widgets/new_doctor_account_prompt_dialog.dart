import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';

class NewDoctorAccountPromptDialog extends StatelessWidget {
  const NewDoctorAccountPromptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.addNewDoctorAccount)),
          SizedBox(width: 10),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      scrollable: false,
      contentPadding: const EdgeInsets.all(8),

      content: Card.outlined(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text.rich(
            TextSpan(
              text: context.loc.addNewDoctorPromptMessageOne,
              children: [
                TextSpan(text: '\n'),
                TextSpan(text: '\n'),
                TextSpan(text: context.loc.addNewDoctorPromptMessageTwo),
              ],
            ),
          ),
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
