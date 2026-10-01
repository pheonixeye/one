import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/contract.dart';
import 'package:one/models/doctor.dart';
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
    required this.doctor,
  });
  final Contract contract;
  final int index;
  final Doctor? doctor;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxContracts, PxLocale>(
      builder: (context, c, l, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.titleHeight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
              tileColor: contract.is_active
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              onTap: () async {
                //@permission
                final _perm = context.read<PxAuth>().isActionPermitted(
                  PermissionEnum.User_Contracts_Modify,
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
                      message: context.loc.activateDeactivateContractPrompt,
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
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  runSpacing: 8,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    SmBtn(
                      tooltip: context.loc.editContract,
                      onPressed: () async {
                        //@permission
                        final _perm = context.read<PxAuth>().isActionPermitted(
                          PermissionEnum.User_Contracts_Modify,
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
                    Text(
                      l.isEnglish ? contract.name_en : contract.name_ar,
                      style: TextStyle(
                        decoration: contract.is_active
                            ? null
                            : TextDecoration.lineThrough,
                      ),
                    ),
                    Card.outlined(
                      elevation: 4,
                      color: Colors.amber.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(32),
                        side: BorderSide(
                          color: Colors.amber,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '${l.isEnglish ? doctor?.name_en : doctor?.name_ar}',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Card.outlined(
                      elevation: 4,
                      color: switch (contract.contract_type) {
                        ContractType.not_specified => Colors.white,
                        ContractType.booking_application =>
                          Colors.indigo.shade200,
                        ContractType.insurance_company => Colors.teal.shade200,
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(32),
                        side: BorderSide(
                          color: switch (contract.contract_type) {
                            ContractType.not_specified => Colors.black45,
                            ContractType.booking_application => Colors.indigo,
                            ContractType.insurance_company => Colors.teal,
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          l.isEnglish
                              ? contract.contract_type.name_en
                              : contract.contract_type.name_ar,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Card.outlined(
                      elevation: 4,
                      color: switch (contract.is_active) {
                        true => Colors.green.shade200,
                        false => Colors.red.shade200,
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(32),
                        side: BorderSide(
                          color: switch (contract.is_active) {
                            true => Colors.green,
                            false => Colors.red,
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          contract.is_active
                              ? context.loc.active
                              : context.loc.inactive,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...contract.contract_data.forWidgets().entries.map((e) {
                    return Text.rich(
                      TextSpan(
                        text: '',
                        children: [
                          WidgetSpan(
                            child: const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: l.isEnglish ? e.value.en : e.value.ar,
                          ),
                          TextSpan(text: ' : '),
                          if (contract.contract_data.toJson()[e.key] == true ||
                              contract.contract_data.toJson()[e.key] == false)
                            WidgetSpan(
                              child: Icon(
                                switch (contract.contract_data
                                    .toJson()[e.key]) {
                                  true => Icons.check,
                                  false => Icons.close,
                                  _ => Icons.error,
                                },
                                color: switch (contract.contract_data
                                    .toJson()[e.key]) {
                                  true => Colors.green,
                                  false => Colors.red,
                                  _ => Colors.transparent,
                                },
                              ),
                            )
                          else
                            TextSpan(
                              text:
                                  '${contract.contract_data.toJson()[e.key] ?? (l.isEnglish ? ContractType.not_specified.name_en : ContractType.not_specified.name_ar)}',
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
