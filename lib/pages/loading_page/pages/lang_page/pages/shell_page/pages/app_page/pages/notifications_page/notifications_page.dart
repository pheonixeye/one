import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/notifications/tokenized_notification.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_pb_notifications.dart';
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

class _NotificationsPageState extends State<NotificationsPage> {
  late final ScrollController _controller;
  late final PxPbNotifications _pxN;

  @override
  void initState() {
    super.initState();
    _pxN = context.read<PxPbNotifications>();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent * 0.8 &&
          !_pxN.isLoading) {
        _pxN.fetchNextBatch();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<PxPbNotifications, PxLocale>(
        builder: (context, n, l, _) {
          while (n.data == null) {
            return CentralLoading();
          }
          while (n.data is ApiErrorResult) {
            return CentralError(
              code: (n.data as ApiErrorResult).errorCode,
              toExecute: n.retry,
            );
          }
          while (n.data != null &&
              (n.data is ApiDataResult) &&
              (n.data as ApiDataResult<List<TokenizedNotification>>)
                  .data
                  .isEmpty) {
            return CentralNoItems(message: context.loc.noItemsFound);
          }
          final _items = n.notifications;
          final _user_id = context.read<PxAuth>().user?.id;
          return ListView.builder(
            controller: _controller,
            itemCount: _items.length + 1,
            itemBuilder: (context, index) {
              if (index == _items.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: n.isLoading
                        ? CircularProgressIndicator()
                        : SizedBox(),
                  ),
                );
              }
              final _item = _items[index];
              final _isNotificationRead = _item.read_by.contains(_user_id);
              return InkWell(
                onTap: _isNotificationRead
                    ? null
                    : () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            if (_user_id != null) {
                              await n.markNotificationAsReadByUser(
                                notification: _item,
                                user_id: _user_id,
                              );
                            }
                          },
                        );
                      },
                child: Card.filled(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(0),
                  ),
                  elevation: _isNotificationRead ? 0 : 6,
                  color: _isNotificationRead
                      ? Colors.teal.shade50
                      : Colors.amber.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_item.title.isNotEmpty)
                          Row(
                            children: [
                              Text(
                                _item.title,
                                style: TextStyle(fontWeight: FontWeight.w700),
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
                        if (_item.body.isNotEmpty) Text(_item.body),
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
          );
        },
      ),
    );
  }
}
