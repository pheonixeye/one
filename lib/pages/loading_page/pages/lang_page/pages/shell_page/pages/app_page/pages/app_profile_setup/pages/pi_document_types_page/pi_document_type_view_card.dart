import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/doctor_items/pi_document_type.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/pi_document_types_page/pi_document_type_create_edit_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_documents.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class PiDocumentTypeViewCard extends StatelessWidget {
  const PiDocumentTypeViewCard({
    super.key,
    required this.piDocumentType,
    required this.index,
  });
  final PiDocumentType piDocumentType;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPiDocuments, PxLocale>(
      builder: (context, d, l, _) {
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
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: l.isEnglish
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              childrenPadding: EdgeInsetsGeometry.directional(
                start: 60,
              ),
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SmBtn(
                      child: Text('${index + 1}'.toArabicNumber(context)),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l.isEnglish
                          ? piDocumentType.name_en
                          : piDocumentType.name_ar,
                    ),
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
                        final _piDocumentType =
                            await showDialog<PiDocumentType?>(
                              context: context,
                              builder: (context) {
                                return PiDocumentTypeCreateEditDialog(
                                  piDocumentType: piDocumentType,
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
                              await d.updateItem(
                                piDocumentType.id,
                                _piDocumentType,
                              );
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
                              await d.deleteItem(piDocumentType.id);
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
                ListTile(
                  title: Text("• ${context.loc.isAllowedOnPortal} : "),
                  subtitle: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Icon(
                      piDocumentType.is_allowed_on_portal
                          ? Icons.check
                          : Icons.close,
                      color: piDocumentType.is_allowed_on_portal
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
