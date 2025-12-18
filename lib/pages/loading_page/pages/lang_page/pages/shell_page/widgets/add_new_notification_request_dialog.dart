import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/notifications/notification_request.dart';
import 'package:one/models/notifications/notification_topic.dart';
import 'package:flutter/material.dart';

class AddNewNotificationRequestDialog extends StatefulWidget {
  const AddNewNotificationRequestDialog({super.key});

  @override
  State<AddNewNotificationRequestDialog> createState() =>
      _AddNewNotificationRequestDialogState();
}

class _AddNewNotificationRequestDialogState
    extends State<AddNewNotificationRequestDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _messageController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.addNewNotification)),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.notificationTitle),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.notificationTitle,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${context.loc.enter} ${context.loc.notificationTitle}';
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.notificationMessage),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: context.loc.notificationMessage,
                  ),
                  minLines: 2,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${context.loc.enter} ${context.loc.notificationMessage}';
                    }
                    return null;
                  },
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
            if (_formKey.currentState!.validate()) {
              final _request = NotificationRequest(
                topic: NotificationTopic.allevia_inclinic,
                title: _titleController.text,
                message: _messageController.text,
              );

              Navigator.pop(context, _request);
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
