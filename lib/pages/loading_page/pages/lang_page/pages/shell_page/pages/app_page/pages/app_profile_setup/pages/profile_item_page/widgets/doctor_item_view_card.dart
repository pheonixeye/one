import 'package:one/extensions/number_translator.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/doctor_items/doctor_doument_type.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/doctor_item_widgets_ext.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/doctor_items/_doctor_item.dart';
import 'package:one/models/doctor_items/doctor_drug_item.dart';
import 'package:one/models/doctor_items/doctor_lab_item.dart';
import 'package:one/models/doctor_items/doctor_procedure_item.dart';
import 'package:one/models/doctor_items/doctor_rad_item.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/dialogs/doctor_item_create_edit_dialog.dart';
import 'package:one/providers/px_doctor_profile_items.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class DoctorItemViewCard extends StatelessWidget {
  const DoctorItemViewCard({
    super.key,
    required this.item,
    required this.index,
  });
  final DoctorItem item;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxDoctorProfileItems, PxLocale>(
      builder: (context, i, l, _) {
        return Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              backgroundColor: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
                side: BorderSide(),
              ),
              trailing: null,
              showTrailingIcon: false,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SmBtn(
                      child: Text('${index + 1}'.toArabicNumber(context)),
                    ),
                  ),
                  Expanded(
                    child: Text(l.isEnglish ? item.name_en : item.name_ar),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SmBtn(
                      onPressed: () async {
                        //@permission
                        final _perm = context.read<PxAuth>().isActionPermitted(
                          PermissionEnum.User_AccountSettings_Modify,
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
                        final _doctorItem =
                            await showDialog<Map<String, dynamic>?>(
                              context: context,
                              builder: (context) {
                                return DoctorItemCreateEditDialog(
                                  type: item.item,
                                  item: item.toJson(),
                                );
                              },
                            );
                        if (_doctorItem == null) {
                          return;
                        }

                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await i.updateItem(_doctorItem);
                            },
                          );
                        }
                      },
                      tooltip: context.loc.update,
                      child: const Icon(Icons.edit),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SmBtn(
                      onPressed: () async {
                        //@permission
                        final _perm = context.read<PxAuth>().isActionPermitted(
                          PermissionEnum.User_AccountSettings_Delete,
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
                        final _doctorItem = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return PromptDialog(
                              message: context.loc.deleteItemPrompt,
                            );
                          },
                        );
                        if (_doctorItem == null || _doctorItem == false) {
                          return;
                        }

                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await i.deleteItem(item);
                            },
                          );
                        }
                      },
                      tooltip: context.loc.delete,
                      backgroundColor: Colors.red.shade300,
                      child: const Icon(Icons.delete_forever),
                    ),
                  ),
                ],
              ),
              children: [
                switch (i.api.item) {
                  ProfileSetupItem.drugs =>
                    (item as DoctorDrugItem).viewWidgets(context),
                  ProfileSetupItem.labs => (item as DoctorLabItem).viewWidgets(
                    context,
                  ),
                  ProfileSetupItem.rads => (item as DoctorRadItem).viewWidgets(
                    context,
                  ),
                  ProfileSetupItem.procedures =>
                    (item as DoctorProcedureItem).viewWidgets(context),
                  ProfileSetupItem.supplies =>
                    (item as DoctorSupplyItem).viewWidgets(context),
                  ProfileSetupItem.documents =>
                    (item as DoctorDocumentTypeItem).viewWidgets(context),
                },
              ],
            ),
          ),
        );
      },
    );
  }
}
