import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';

class BookingUrlDialog extends StatelessWidget {
  const BookingUrlDialog({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.link)),
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
            Card.outlined(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        iconSize: 16,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: url));
                        },
                        icon: const Icon(Icons.copy),
                      ),
                    ),
                    Expanded(
                      child: SelectableText(
                        url,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
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
            Navigator.pop(context, true);
          },
          label: Text(context.loc.confirm),
          icon: Icon(Icons.check, color: Colors.green.shade100),
        ),
      ],
    );
  }
}
