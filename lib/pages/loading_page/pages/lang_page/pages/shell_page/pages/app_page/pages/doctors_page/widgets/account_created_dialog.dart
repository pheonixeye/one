import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AccountCreatedDialog extends StatelessWidget {
  const AccountCreatedDialog({super.key});

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
      scrollable: true,
      contentPadding: const EdgeInsets.all(8),
      content: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(AppAssets.bgSvg, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              context.loc.verificationEmailSent,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, null);
          },
          label: Text(context.loc.confirm),
          icon: const Icon(Icons.check, color: Colors.green),
        ),
      ],
    );
  }
}
