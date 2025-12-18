import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/weekdays.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class SelectWeekdayDialog extends StatelessWidget {
  const SelectWeekdayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.addWorkingWeekday)),
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
      insetPadding: const EdgeInsets.all(8),
      content: Consumer<PxLocale>(
        builder: (context, l, _) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...Weekdays.weekdays.map((e) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip.elevated(
                    label: Text(l.isEnglish ? e.en : e.ar),
                    onSelected: (val) {
                      Navigator.pop(context, e.id);
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
