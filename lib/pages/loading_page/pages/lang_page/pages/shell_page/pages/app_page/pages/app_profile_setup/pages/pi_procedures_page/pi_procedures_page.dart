import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/profile_setup_item_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/doctor_items/pi_procedure.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/pi_procedures_page/pi_procedure_create_edit_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/pi_procedures_page/pi_procedure_view_card.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_procedures.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class PiProceduresPage extends StatefulWidget {
  const PiProceduresPage({super.key});

  @override
  State<PiProceduresPage> createState() => _PiProceduresPageState();
}

class _PiProceduresPageState extends State<PiProceduresPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPiProcedures, PxLocale>(
      builder: (context, p, l, _) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmBtn(
                            tooltip: context.loc.back,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        Text(
                          ProfileSetupItem.procedures.pageTitleName(context),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText:
                                    context.loc.searchByEnglishOrArabicItemName,
                              ),
                              controller: _controller,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  p.clearSearch();
                                }
                                p.searchForItems(value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SmBtn(
                            tooltip: context.loc.clearSearch,
                            onPressed: () {
                              p.clearSearch();
                              _controller.clear();
                            },
                            backgroundColor: Colors.red.shade300,
                            child: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                    subtitle: const Divider(),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      while (p.procedures == null) {
                        return const CentralLoading();
                      }

                      while (p.procedures is ApiErrorResult) {
                        return CentralError(
                          code: (p.procedures as ApiErrorResult).errorCode,
                          toExecute: p.retry,
                        );
                      }

                      while (p.procedures != null &&
                          (p.procedures is ApiDataResult) &&
                          (p.procedures as ApiDataResult<List<PiProcedure>>)
                              .data
                              .isEmpty) {
                        return CentralNoItems(
                          message:
                              '${context.loc.noItemsFound}\n(${PiProcedure.item.pageTitleName(context)})',
                        );
                      }
                      final _items =
                          (p.filteredProcedures
                                  as ApiDataResult<List<PiProcedure>>)
                              .data;
                      return ListView.builder(
                        itemCount: _items.length,
                        cacheExtent: 3000,
                        itemBuilder: (context, index) {
                          final _piProcedure = _items[index];
                          return PiProcedureViewCard(
                            piProcedure: _piProcedure,
                            index: index,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: SmBtn(
            tooltip: ProfileSetupItem.procedures.actionButtonTooltip(context),
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_AccountSettings_Add,
                context,
              );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(permission: _perm.permission);
                  },
                );
                return;
              }
              final _piProcedure = await showDialog<PiProcedure?>(
                context: context,
                builder: (context) {
                  return PiProcedureCreateEditDialog(
                    piProcedure: null,
                  );
                },
              );
              if (_piProcedure == null) {
                return;
              }

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await p.createItem(_piProcedure);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
