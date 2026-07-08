import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/profile_setup_item_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/doctor_items/pi_drug.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/pi_drugs_page/pi_drug_create_edit_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/pi_drugs_page/pi_drug_view_card.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_drugs.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class PiDrugsPage extends StatefulWidget {
  const PiDrugsPage({super.key});

  @override
  State<PiDrugsPage> createState() => _PiDrugsPageState();
}

class _PiDrugsPageState extends State<PiDrugsPage> {
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
    return Consumer2<PxPiDrugs, PxLocale>(
      builder: (context, d, l, _) {
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
                        Text(ProfileSetupItem.drugs.pageTitleName(context)),
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
                                  d.clearSearch();
                                }
                                d.searchForItems(value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SmBtn(
                            tooltip: context.loc.clearSearch,
                            onPressed: () {
                              d.clearSearch();
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
                      while (d.drugs == null) {
                        return const CentralLoading();
                      }

                      while (d.drugs is ApiErrorResult) {
                        return CentralError(
                          code: (d.drugs as ApiErrorResult).errorCode,
                          toExecute: d.retry,
                        );
                      }

                      while (d.drugs != null &&
                          (d.drugs is ApiDataResult) &&
                          (d.drugs as ApiDataResult<List<PiDrug>>)
                              .data
                              .isEmpty) {
                        return CentralNoItems(
                          message:
                              '${context.loc.noItemsFound}\n(${PiDrug.item.pageTitleName(context)})',
                        );
                      }
                      final _items =
                          (d.filteredDrugs as ApiDataResult<List<PiDrug>>).data;
                      return ListView.builder(
                        itemCount: _items.length,
                        cacheExtent: 3000,
                        itemBuilder: (context, index) {
                          final _piDrug = _items[index];
                          return PiDrugViewCard(
                            piDrug: _piDrug,
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
            tooltip: ProfileSetupItem.drugs.actionButtonTooltip(context),
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
              final _piDrug = await showDialog<PiDrug?>(
                context: context,
                builder: (context) {
                  return PiDrugCreateEditDialog(
                    piDrug: null,
                  );
                },
              );
              if (_piDrug == null) {
                return;
              }

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await d.createItem(_piDrug);
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
