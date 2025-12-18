import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/reciept_info.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/reciept_settings/create_new_reciept_info_dialog.dart';
import 'package:one/providers/px_reciept_info.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecieptSettingsSection extends StatelessWidget {
  const RecieptSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxRecieptInfo>(
      builder: (context, r, _) {
        while (r.result == null) {
          return const SizedBox(
            height: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: LinearProgressIndicator(),
            ),
          );
        }
        while (r.result is ApiErrorResult) {
          final _err = (r.result as ApiErrorResult).errorCode;
          return CentralError(
            code: _err,
            toExecute: () async {
              await r.retry();
            },
          );
        }
        final _data = (r.result as ApiDataResult<List<RecieptInfo>>).data;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(context.loc.recieptSettings),
                ),
                subtitle: const Divider(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(context.loc.storedReciepts),
                      trailing: SmBtn(
                        tooltip: context.loc.addRecieptInfo,
                        onPressed: () async {
                          final _recieptInfo = await showDialog<RecieptInfo?>(
                            context: context,
                            builder: (context) {
                              return CreateNewRecieptInfoDialog();
                            },
                          );
                          if (_recieptInfo == null) {
                            return;
                          }
                          if (context.mounted) {
                            await shellFunction(
                              context,
                              toExecute: () async {
                                await r.addRecieptInfo(_recieptInfo);
                              },
                            );
                          }
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                  if (_data.isEmpty)
                    Text(context.loc.noItemsFound)
                  else
                    ..._data.map((info) {
                      final _index = _data.indexOf(info);
                      return ListTile(
                        titleAlignment: ListTileTitleAlignment.titleHeight,
                        leading: SmBtn(
                          child: Text('${_index + 1}'.toArabicNumber(context)),
                        ),
                        title: Text(info.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: context.loc.recieptSubtitle,
                                children: [
                                  TextSpan(text: ' : '),
                                  TextSpan(text: info.subtitle),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: context.loc.recieptFooter,
                                children: [
                                  TextSpan(text: ' : '),
                                  TextSpan(text: info.footer),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: context.loc.recieptAddress,
                                children: [
                                  TextSpan(text: ' : '),
                                  TextSpan(text: info.address),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: context.loc.recieptPhone,
                                children: [
                                  TextSpan(text: ' : '),
                                  TextSpan(text: info.phone),
                                ],
                              ),
                            ),
                          ],
                        ),
                        trailing: Checkbox(
                          value: r.info?.id == info.id,
                          onChanged: (value) async {
                            if (r.info?.id == info.id) {
                              return;
                            } else {
                              await shellFunction(
                                context,
                                toExecute: () async {
                                  await r.markInfoAsDefaultForDevice(info);
                                },
                              );
                            }
                          },
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
