import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:provider/provider.dart';

class CommentsPicker extends StatelessWidget {
  const CommentsPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxAddNewVisitDialog>(
      builder: (context, s, _) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(context.loc.comments),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    controller: s.commentsController,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
