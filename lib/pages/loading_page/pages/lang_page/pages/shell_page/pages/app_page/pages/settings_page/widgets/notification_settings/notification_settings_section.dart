import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/px_firebase_notifications.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class NotificationSettingsSection extends StatelessWidget {
  const NotificationSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer2<PxFirebaseNotifications, PxLocale>(
            builder: (context, f, l, _) {
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(context.loc.notificationSettings),
                ),

                trailing: SmBtn(
                  tooltip: context.loc.howToToggleNotifications,
                  onPressed: () async {
                    web.window.open(
                      'https://www.youtube.com/watch?v=yBrJeLcLQso',
                      '_blank',
                    );
                  },
                  child: f.isAuthorized
                      ? const Icon(Icons.notifications_active)
                      : const Icon(Icons.notifications_off),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          text: context.loc.status,
                          children: [
                            TextSpan(text: ' : '),
                            TextSpan(
                              text: f.authorizationStatus
                                  ?.authorizationStatusTr(
                                    l.isEnglish,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
