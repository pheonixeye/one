import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/user/user.dart';
import 'package:one/models/user/user_with_password.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/assistants_page/widgets/add_assistant_account_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/assistants_page/widgets/update_account_name_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_assistant_accounts.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/not_permitted_template_page.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssistantsPage extends StatelessWidget {
  const AssistantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxAssistantAccounts, PxLocale>(
      builder: (context, a, c, l, _) {
        while (PxAuth.isUserNotDoctor) {
          return NotPermittedTemplatePage(title: context.loc.assistantAccounts);
        }
        return Scaffold(
          floatingActionButton: SmBtn(
            onPressed: () async {
              final _userWithPassword = await showDialog<UserWithPassword?>(
                context: context,
                builder: (context) {
                  return AddAssistantAccountDialog();
                },
              );
              if (_userWithPassword == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await c.addAssistantAccount(_userWithPassword);
                  },
                );
              }
            },
            tooltip: context.loc.addAssistantAccount,
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.assistantAccounts),
                  ),
                  subtitle: const Divider(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (a.constants == null || c.users == null) {
                      return CentralLoading();
                    }
                    while (c.users is ApiErrorResult) {
                      final _err = c.users as ApiErrorResult<List<User>>;
                      return CentralError(
                        code: _err.errorCode,
                        toExecute: c.retry,
                      );
                    }

                    final items = (c.users as ApiDataResult<List<User>>).data;

                    while (items.isEmpty) {
                      return CentralNoItems(message: context.loc.noItemsFound);
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card.outlined(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ExpansionTile(
                                title: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SmBtn(child: Text('${index + 1}')),
                                    ),
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        decoration: item.is_active
                                            ? null
                                            : TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton.outlined(
                                      tooltip: context.loc.editAccountName,
                                      onPressed: () async {
                                        //@permission
                                        final _perm = context
                                            .read<PxAuth>()
                                            .isActionPermitted(
                                              PermissionEnum
                                                  .User_AccountSettings_Modify,
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
                                        final _name = await showDialog<String?>(
                                          context: context,
                                          builder: (context) {
                                            return const UpdateAccountNameDialog();
                                          },
                                        );

                                        if (_name == null) {
                                          return;
                                        }

                                        if (context.mounted) {
                                          await shellFunction(
                                            context,
                                            toExecute: () async {
                                              await c.updateAccountName(
                                                item.id,
                                                _name,
                                              );
                                            },
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: item.is_active
                                            ? Colors.red.shade200
                                            : Colors.green.shade200,
                                      ),
                                      label: Text(
                                        item.is_active
                                            ? context.loc.deactivateAccount
                                            : context.loc.activateAccount,
                                      ),
                                      icon: item.is_active
                                          ? Icon(Icons.close)
                                          : Icon(Icons.check),
                                      onPressed: () async {
                                        //@permission
                                        final _perm = context
                                            .read<PxAuth>()
                                            .isActionPermitted(
                                              PermissionEnum
                                                  .User_AccountSettings_Modify,
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
                                        final _toToogle = await showDialog<bool?>(
                                          context: context,
                                          builder: (context) {
                                            return PromptDialog(
                                              message: context
                                                  .loc
                                                  .toogleAccountActivityPrompt,
                                            );
                                          },
                                        );
                                        if (_toToogle == null ||
                                            _toToogle == false) {
                                          return;
                                        }
                                        if (context.mounted) {
                                          await shellFunction(
                                            context,
                                            toExecute: () async {
                                              await c.toogleActivity(
                                                item.id,
                                                !item.is_active,
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                subtitle: ListTile(
                                  leading: const SizedBox(),
                                  title: Row(
                                    spacing: 4,
                                    children: [
                                      Text(context.loc.email),
                                      Text(' : '),
                                      Text(item.email),
                                    ],
                                  ),
                                  subtitle: const Divider(color: Colors.grey),
                                ),
                                children: [
                                  ...a.constants!.appPermission.map((perm) {
                                    return CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                        l.isEnglish
                                            ? perm.name_en
                                            : perm.name_ar,
                                      ),
                                      subtitle: const Divider(
                                        color: Colors.grey,
                                      ),
                                      value: item.app_permissions.contains(
                                        perm,
                                      ),
                                      onChanged: (val) async {
                                        if (a.isUnchangablePermission(
                                          perm.id,
                                        )) {
                                          showIsnackbar(
                                            context.loc.cannotChangeAccountType,
                                          );
                                          return;
                                        } else {
                                          if (item.app_permissions.contains(
                                            perm,
                                          )) {
                                            await shellFunction(
                                              context,
                                              toExecute: () async {
                                                await c.removeAccountPermission(
                                                  item.id,
                                                  perm.id,
                                                );
                                              },
                                            );
                                          } else {
                                            await shellFunction(
                                              context,
                                              toExecute: () async {
                                                await c.addAccountPermission(
                                                  item.id,
                                                  perm.id,
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
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
            ],
          ),
        );
      },
    );
  }
}
