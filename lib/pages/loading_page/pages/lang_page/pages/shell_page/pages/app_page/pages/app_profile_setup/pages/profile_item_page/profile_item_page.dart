import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/doctor_items/_doctor_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/dialogs/doctor_item_create_edit_dialog.dart';
import 'package:one/extensions/profile_setup_item_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/profile_item_page/widgets/doctor_item_view_card.dart';
import 'package:one/providers/px_doctor_profile_items.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class ProfileItemPage extends StatefulWidget {
  const ProfileItemPage({
    super.key,
    //drugs-labs-rads-procedures-supplies
    required this.profileSetupItem,
  });
  final ProfileSetupItem profileSetupItem;

  @override
  State<ProfileItemPage> createState() => _ProfileItemPageState();
}

class _ProfileItemPageState extends State<ProfileItemPage> {
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
    return Consumer2<PxDoctorProfileItems, PxLocale>(
      builder: (context, i, l, _) {
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
                        Text(widget.profileSetupItem.pageTitleName(context)),
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
                                  i.clearSearch();
                                }
                                i.searchForItems(value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SmBtn(
                            tooltip: context.loc.clearSearch,
                            onPressed: () {
                              i.clearSearch();
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
                      while (i.data == null) {
                        return const CentralLoading();
                      }

                      while (i.data is ApiErrorResult) {
                        return CentralError(
                          code: (i.data as ApiErrorResult).errorCode,
                          toExecute: i.retry,
                        );
                      }

                      while (i.data != null &&
                          (i.data is ApiDataResult) &&
                          (i.data as ApiDataResult<List<DoctorItem>>)
                              .data
                              .isEmpty) {
                        return CentralNoItems(
                          message:
                              '${context.loc.noItemsFound}\n(${widget.profileSetupItem.pageTitleName(context)})',
                        );
                      }
                      final _items =
                          (i.filteredData as ApiDataResult<List<DoctorItem>>)
                              .data;
                      return ListView.builder(
                        itemCount: _items.length,
                        cacheExtent: 3000,
                        itemBuilder: (context, index) {
                          final _profileItem = _items[index];
                          return DoctorItemViewCard(
                            item: _profileItem,
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
            tooltip: widget.profileSetupItem.actionButtonTooltip(context),
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
              final _doctorItemJson = await showDialog<Map<String, dynamic>?>(
                context: context,
                builder: (context) {
                  return DoctorItemCreateEditDialog(
                    type: widget.profileSetupItem,
                    item: null,
                  );
                },
              );
              if (_doctorItemJson == null) {
                return;
              }

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await i.addNewItem(_doctorItemJson);
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
