import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/whatsapp_tile/whatsapp_qr_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_whatsapp.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WhatsappTile extends StatelessWidget {
  const WhatsappTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxWhatsapp>(
      builder: (context, w, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(context.loc.whatsappSettings),
                ),
                isThreeLine: true,
                trailing: ThemedPopupmenuBtn(
                  tooltip: context.loc.settings,
                  icon: const Icon(Icons.menu),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.whatsapp),
                            SizedBox(width: 4),
                            Text(context.loc.connectWhatsapp),
                          ],
                        ),
                        onTap: () async {
                          //@permission
                          final _perm = context
                              .read<PxAuth>()
                              .isActionPermitted(
                                PermissionEnum.User_Whatsapp_Login,
                                context,
                              );
                          if (!_perm.isAllowed) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return NotPermittedDialog(
                                  permission: _perm.permission,
                                );
                              },
                            );
                            return;
                          }

                          await shellFunction(
                            context,
                            toExecute: () async {
                              await w.login();
                            },
                            duration: const Duration(milliseconds: 100),
                          );
                          if (w.serverResult != null &&
                              w.serverResult!.results == null &&
                              context.mounted) {
                            showIsnackbar('${w.serverResult?.message}');
                            return;
                          }
                          if (w.serverResult == null && context.mounted) {
                            showIsnackbar(context.loc.error);
                            return;
                          }

                          if (context.mounted) {
                            await showDialog<void>(
                              context: context,
                              builder: (context) {
                                return WhatsappQrDialog(
                                  qrLink: w.serverResult!.results!.qr_link,
                                );
                              },
                            ).whenComplete(() async {
                              await w.fetchConnectedDevices();
                            });
                          }
                        },
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            const Icon(Icons.device_hub),
                            SizedBox(width: 4),
                            Text(context.loc.showConnectedwhatsappDevices),
                          ],
                        ),
                        onTap: () async {
                          //@permission
                          final _perm = context
                              .read<PxAuth>()
                              .isActionPermitted(
                                PermissionEnum.User_Whatsapp_Fetch_Devices,
                                context,
                              );
                          if (!_perm.isAllowed) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return NotPermittedDialog(
                                  permission: _perm.permission,
                                );
                              },
                            );
                            return;
                          }
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await w.fetchConnectedDevices();
                            },
                          );
                        },
                      ),
                    ];
                  },
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const SmBtn(),
                      titleAlignment: ListTileTitleAlignment.top,
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.whatsappDevices),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (w.connectedDevices != null &&
                              w.connectedDevices!.results != null) ...[
                            ...w.connectedDevices!.results!.map((e) {
                              return Card.outlined(
                                elevation: 2,
                                color: Colors.amber.shade50,
                                child: ListTile(
                                  leading: SmBtn(onPressed: null),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(e.name),
                                  ),
                                  subtitle: Text(
                                    e.device,
                                    textDirection: TextDirection.ltr,
                                  ),
                                  trailing: SmBtn(
                                    tooltip: context.loc.logout,
                                    onPressed: () async {
                                      //@permission
                                      final _perm = context
                                          .read<PxAuth>()
                                          .isActionPermitted(
                                            PermissionEnum.User_Whatsapp_Logout,
                                            context,
                                          );
                                      if (!_perm.isAllowed) {
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return NotPermittedDialog(
                                              permission: _perm.permission,
                                            );
                                          },
                                        );
                                        return;
                                      }
                                      final _toLogout = await showDialog<bool?>(
                                        context: context,
                                        builder: (context) {
                                          return PromptDialog(
                                            message: context.loc.logoutPrompt,
                                          );
                                        },
                                      );
                                      if (_toLogout == null ||
                                          _toLogout == false) {
                                        return;
                                      }
                                      if (context.mounted) {
                                        await shellFunction(
                                          context,
                                          toExecute: () async {
                                            await w.logout();
                                          },
                                        );
                                      }
                                    },
                                    child: const Icon(Icons.logout),
                                  ),
                                ),
                              );
                            }),
                          ],
                          if (w.connectedDevices == null)
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(context.loc.noConnectedDevices),
                              ),
                            ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
