import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/changelog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeLogDialog extends StatelessWidget {
  const ChangeLogDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.loc.changeLog,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Consumer<PxLocale>(
          builder: (context, l, _) {
            return ListView.builder(
              itemCount: CHANGELOG.length,
              itemBuilder: (context, index) {
                final _item = CHANGELOG[index];
                return Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      leading: const SmBtn(),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_item.version),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          ..._item.entries.map((log) {
                            final _index = _item.entries.indexOf(log);
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              runAlignment: WrapAlignment.start,
                              children: [
                                IconButton.outlined(
                                  onPressed: null,
                                  icon: Text('${_index + 1}'),
                                ),
                                Text(l.isEnglish ? log.en : log.ar),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
