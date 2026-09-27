import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/contract.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/contracts_page/widgets/contract_view_edit_card.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/contracts_page/widgets/create_edit_contract_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_contracts.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/not_permitted_template_page.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class ContractsPage extends StatelessWidget {
  const ContractsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<PxAppConstants, PxDoctor, PxContracts, PxLocale>(
      builder: (context, a, d, c, l, _) {
        while (a.constants == null || d.allDoctors == null || c.data == null) {
          return const CentralLoading();
        }
        //@permission
        final _perm = context.read<PxAuth>().isActionPermitted(
          PermissionEnum.User_Contracts_Read,
          context,
        );
        while (!_perm.isAllowed) {
          return NotPermittedTemplatePage(title: context.loc.contracts);
        }
        return Scaffold(
          floatingActionButton: SmBtn(
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_Contracts_Add,
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
              //todo: add new form Dialog
              final _contract = await showDialog<Contract?>(
                context: context,
                builder: (context) {
                  return const CreateEditContractDialog();
                },
              );
              if (_contract == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    //todo:
                    await c.addNewContract(_contract);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.contracts),
                  ),
                  subtitle: Column(
                    children: [
                      if (context.read<PxAuth>().isLoggedInUserSuperAdmin(
                        context,
                      ))
                        SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              const Spacer(),
                              const Icon(Icons.filter_alt),
                              Expanded(
                                child: DropdownButtonFormField<String?>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  initialValue: null,
                                  isExpanded: true,
                                  alignment: Alignment.center,
                                  items: [
                                    DropdownMenuItem(
                                      value: null,
                                      alignment: Alignment.center,
                                      child: Text(
                                        context.loc.allContracts,
                                      ),
                                    ),
                                    if (d.allDoctors != null)
                                      ...d.allDoctors!.map((e) {
                                        return DropdownMenuItem(
                                          value: e.id,
                                          alignment: Alignment.center,
                                          child: Text(
                                            l.isEnglish ? e.name_en : e.name_ar,
                                          ),
                                        );
                                      }),
                                  ],
                                  onChanged: (val) {
                                    c.filterContracts(doc_id: val);
                                  },
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (c.data == null || d.allDoctors == null) {
                      return const CentralLoading();
                    }

                    while (c.data is ApiErrorResult) {
                      return CentralError(
                        code: (c.data as ApiErrorResult).errorCode,
                        toExecute: c.retry,
                      );
                    }
                    final _data = c.filteredContracts;
                    final _doctors = d.allDoctors;

                    while (_data != null && _data.isEmpty) {
                      return Center(
                        child: Card.outlined(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(context.loc.noContractsFound),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: _data == null ? 0 : _data.length,
                      itemBuilder: (context, index) {
                        final item = _data![index];
                        final _doctor = _doctors?.firstWhereOrNull(
                          (e) => e.id == item.doc_id,
                        );
                        return ContractViewEditCard(
                          doctor: _doctor,
                          contract: item,
                          index: index,
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
