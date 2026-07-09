import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/profile_setup_item_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/doctor_items/pi_document_type.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/pi_document_types_page/pi_document_type_create_edit_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/pi_document_types_page/pi_document_type_view_card.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_documents.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class PiDocumentTypesPage extends StatefulWidget {
  const PiDocumentTypesPage({super.key});

  @override
  State<PiDocumentTypesPage> createState() => _PiDocumentTypesPageState();
}

class _PiDocumentTypesPageState extends State<PiDocumentTypesPage> {
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
    return Consumer2<PxPiDocuments, PxLocale>(
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
                        Text(ProfileSetupItem.documents.pageTitleName(context)),
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
                      while (d.documentTypes == null) {
                        return const CentralLoading();
                      }

                      while (d.documentTypes is ApiErrorResult) {
                        return CentralError(
                          code: (d.documentTypes as ApiErrorResult).errorCode,
                          toExecute: d.retry,
                        );
                      }

                      while (d.documentTypes != null &&
                          (d.documentTypes is ApiDataResult) &&
                          (d.documentTypes
                                  as ApiDataResult<List<PiDocumentType>>)
                              .data
                              .isEmpty) {
                        return CentralNoItems(
                          message:
                              '${context.loc.noItemsFound}\n(${PiDocumentType.item.pageTitleName(context)})',
                        );
                      }
                      final _items =
                          (d.filteredDocumentTypes
                                  as ApiDataResult<List<PiDocumentType>>)
                              .data;
                      return ListView.builder(
                        itemCount: _items.length,
                        cacheExtent: 3000,
                        itemBuilder: (context, index) {
                          final _piDocumentType = _items[index];
                          return PiDocumentTypeViewCard(
                            piDocumentType: _piDocumentType,
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
              final _piDocumentType = await showDialog<PiDocumentType?>(
                context: context,
                builder: (context) {
                  return PiDocumentTypeCreateEditDialog(
                    piDocumentType: null,
                  );
                },
              );
              if (_piDocumentType == null) {
                return;
              }

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await d.createItem(_piDocumentType);
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
