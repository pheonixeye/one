import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/contract.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/contracts_page/widgets/create_edit_contract_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_contracts.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class ContractViewEditCard extends StatelessWidget {
  const ContractViewEditCard({
    super.key,
    required this.contract,
    required this.index,
  });
  final Contract contract;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxContracts, PxLocale>(
      builder: (context, c, l, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.titleHeight,
                leading: SmBtn(
                  child: Text('${index + 1}'.toArabicNumber(context)),
                ),

                tileColor: contract.is_active
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 4,
                    children: [
                      Text(
                        l.isEnglish ? contract.name_en : contract.name_ar,
                        style: TextStyle(
                          decoration: contract.is_active
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        '(${contract.is_active ? context.loc.active : context.loc.inactive})',
                      ),
                      const Spacer(),
                      SmBtn(
                        tooltip: context.loc.contractActivity,
                        onPressed: () async {
                          //@permission
                          final _perm = context
                              .read<PxAuth>()
                              .isActionPermitted(
                                PermissionEnum.User_Contracts_Modify,
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
                          final _toToggle = await showDialog<bool?>(
                            context: context,
                            builder: (context) {
                              return PromptDialog(
                                message: context
                                    .loc
                                    .activateDeactivateContractPrompt,
                              );
                            },
                          );
                          if (_toToggle == null || _toToggle == false) {
                            return;
                          }

                          if (context.mounted) {
                            await shellFunction(
                              context,
                              toExecute: () async {
                                final _updated = contract.copyWith(
                                  is_active: !contract.is_active,
                                );
                                await c.updateContract(
                                  contract.id,
                                  _updated,
                                );
                              },
                            );
                          }
                        },
                        backgroundColor: contract.is_active
                            ? Colors.red.shade200
                            : Colors.green.shade200,
                        child: Icon(
                          contract.is_active ? Icons.close : Icons.check,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SmBtn(
                        tooltip: context.loc.editContract,
                        onPressed: () async {
                          //@permission
                          final _perm = context
                              .read<PxAuth>()
                              .isActionPermitted(
                                PermissionEnum.User_Contracts_Modify,
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

                          final _updated = await showDialog<Contract?>(
                            context: context,
                            builder: (context) {
                              return CreateEditContractDialog(
                                contract: contract,
                              );
                            },
                          );

                          if (_updated == null) {
                            return;
                          }
                          if (context.mounted) {
                            await shellFunction(
                              context,
                              toExecute: () async {
                                await c.updateContract(
                                  contract.id,
                                  _updated,
                                );
                              },
                            );
                          }
                        },

                        child: const Icon(Icons.edit),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                subtitle: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(context.loc.patientPercent),
                        Text(' : '),
                        Text('${contract.patient_percent} %'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(context.loc.consultationCost),
                        Text(' : '),
                        Text(
                          '${contract.consultation_cost} ${context.loc.egp}',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(context.loc.followupCost),
                        Text(' : '),
                        Text(
                          '${contract.followup_cost} ${context.loc.egp}',
                        ),
                      ],
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
