import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/notifications/notification_request.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/add_new_notification_request_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/monthly_visits_calendar_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_notifications.dart';
import 'package:one/providers/px_whatsapp.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NavBarMenuBtn extends StatelessWidget {
  const NavBarMenuBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxNotifications, PxLocale>(
      builder: (context, n, l, _) {
        return ThemedPopupmenuBtn<void>(
          icon: const Icon(Icons.notification_add),
          tooltip: context.loc.notifications,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Consumer<PxWhatsapp>(
                  builder: (context, w, _) {
                    while (w.serverResult == null) {
                      return const SizedBox(
                        width: 30,
                        height: 8,
                        child: LinearProgressIndicator(),
                      );
                    }
                    return ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      onTap: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await w.reconnect();
                            await w.fetchConnectedDevices();
                          },
                        );
                      },
                      leading: Icon(
                        w.isConnectedToServer
                            ? FontAwesomeIcons.whatsapp
                            : Icons.wifi_off_rounded,
                        color: w.isConnectedToServer
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(context.loc.whatsappSettings),
                      subtitle: Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (!w.isConnectedToServer)
                            Text.rich(
                              TextSpan(
                                text: context.loc.notConntectedToWhatsappServer,
                                children: [
                                  TextSpan(text: '\n'),
                                  TextSpan(
                                    text: context.loc.noConnectedDevices,
                                  ),
                                ],
                              ),
                            )
                          else
                            Text.rich(
                              TextSpan(
                                text: context.loc.conntectedToWhatsappServer,
                                children: w.hasConnectedDevices
                                    ? [
                                        TextSpan(text: '\n'),
                                        if (w.connectedDevices != null)
                                          ...w.connectedDevices!.results!.map((
                                            e,
                                          ) {
                                            final dev = e.device.split('@');
                                            return TextSpan(
                                              text: dev[0],
                                              children: [
                                                TextSpan(text: '\n'),
                                                TextSpan(text: dev[1]),
                                              ],
                                            );
                                          }),
                                      ]
                                    : [
                                        TextSpan(text: '\n'),
                                        TextSpan(
                                          text: context.loc.noConnectedDevices,
                                        ),
                                      ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(context.loc.visitsCalender),
                  titleAlignment: ListTileTitleAlignment.top,
                  onTap: () async {
                    await showGeneralDialog<void>(
                      context: context,
                      pageBuilder: (context, a1, a2) {
                        return MonthlyVisitsCalendarDialog();
                      },
                      anchorPoint: Offset(100, 100),
                      transitionDuration: const Duration(milliseconds: 600),
                      transitionBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              alignment: Alignment.topLeft,
                              scale: animation,
                              child: child,
                            );
                          },
                    );
                  },
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                child: PopupMenuButton<void>(
                  offset: l.isEnglish ? Offset(-200, 25) : Offset(200, 25),
                  elevation: 6,
                  // icon: const Icon(Icons.settings),
                  shadowColor: Colors.transparent,
                  color: Colors.amber.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.add),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(context.loc.addNewNotification),
                          ),
                          onTap: () async {
                            final _notificationRequest =
                                await showDialog<NotificationRequest?>(
                                  context: context,
                                  builder: (context) {
                                    return const AddNewNotificationRequestDialog();
                                  },
                                );
                            if (_notificationRequest == null) {
                              return;
                            }
                            if (context.mounted) {
                              await shellFunction(
                                context,
                                toExecute: () async {
                                  await n.saveFavoriteNotification(
                                    _notificationRequest,
                                  );
                                },
                              ).whenComplete(() {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                        ),
                      ),
                      PopupMenuDivider(),
                      if (n.favoriteNotifications == null)
                        PopupMenuItem(
                          child: const SizedBox(
                            width: 100,
                            height: 8,
                            child: LinearProgressIndicator(),
                          ),
                        )
                      else
                        ...n.favoriteNotifications!.map((fav) {
                          final _index = n.favoriteNotifications!.indexOf(fav);
                          return PopupMenuItem(
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    '(${_index + 1})'.toArabicNumber(context),
                                  ),
                                  Text(fav.title ?? ''),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(fav.message ?? ''),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Divider(),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await n.sendNotification(
                                      topic: fav.topic,
                                      request: fav,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        }),
                    ];
                  },
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.top,
                    leading: const Icon(Icons.notification_add),
                    title: Text(context.loc.notifications),
                  ),
                ),
              ),
              // PopupMenuDivider(),
              // PopupMenuItem(
              //   child: ListTile(
              //     title: Text('sendTestNotification'),
              //     onTap: () async {
              //       final _request = NotificationRequest(
              //         topic: NotificationTopic.allevia_testing,
              //         title: 'test-notification-sound',
              //         message:
              //             'Discover 10 groundbreaking AI-driven technologies that are reshaping how organizations perform maintenance, engage with customers, secure data, deliver healthcare, and more.',
              //       );
              //       await shellFunction(
              //         context,
              //         toExecute: () async {
              //           await n.sendNotification(
              //             topic: _request.topic,
              //             request: _request,
              //           );
              //         },
              //       );
              //     },
              //   ),
              // ),
            ];
          },
        );
      },
    );
  }
}
