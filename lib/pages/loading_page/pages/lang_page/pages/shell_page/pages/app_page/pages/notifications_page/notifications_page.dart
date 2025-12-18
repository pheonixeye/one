import 'dart:async';

import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/after_layout.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/notifications/saved_notification.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_notifications.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with AfterLayoutMixin {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await context.read<PxNotifications>().retry();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<PxNotifications, PxLocale>(
        builder: (context, n, l, _) {
          while (n.notifications == null) {
            return CentralLoading();
          }
          while (n.notifications is ApiErrorResult) {
            return CentralError(
              code: (n.notifications as ApiErrorResult).errorCode,
              toExecute: n.retry,
            );
          }
          while (n.notifications != null &&
              (n.notifications is ApiDataResult) &&
              (n.notifications as ApiDataResult<List<SavedNotification>>)
                  .data
                  .isEmpty) {
            return CentralNoItems(message: context.loc.noItemsFound);
          }
          final _items =
              (n.notifications as ApiDataResult<List<SavedNotification>>).data;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final _item = _items[index];
                    final _isNotificationRead = _item.read_by
                        .map((e) => e.id)
                        .toList()
                        .contains(PxAuth.doc_id_static_getter);
                    return Card.filled(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(0),
                      ),
                      elevation: _isNotificationRead ? 0 : 6,
                      color: _isNotificationRead
                          ? Colors.white
                          : _item.notification_topic.tileColor,
                      child: InkWell(
                        onTap: _isNotificationRead
                            ? null
                            : () async {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await n.readNotification(
                                      _item.id,
                                      PxAuth.doc_id_static_getter,
                                    );
                                  },
                                );
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            spacing: 4,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '(${index + 1})'.toArabicNumber(context),
                                  ),
                                  Card.outlined(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        l.isEnglish
                                            ? _item.notification_topic.en
                                            : _item.notification_topic.ar,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (_isNotificationRead)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                              if (_item.title.isNotEmpty)
                                Text(
                                  _item.title,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              if (_item.message.isNotEmpty) Text(_item.message),
                              Text(
                                DateFormat(
                                  'dd/MM/yyyy-HH:MM',
                                  l.lang,
                                ).format(DateTime.parse(_item.created)),
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(
                      tooltip: context.loc.previous,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await n.previousPage();
                          },
                          duration: const Duration(milliseconds: 100),
                        );
                        _controller.animateTo(
                          0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('- ${n.page} -'),
                    ),
                    IconButton.outlined(
                      tooltip: context.loc.next,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await n.nextPage();
                          },
                          duration: const Duration(milliseconds: 100),
                        );
                        _controller.animateTo(
                          0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
