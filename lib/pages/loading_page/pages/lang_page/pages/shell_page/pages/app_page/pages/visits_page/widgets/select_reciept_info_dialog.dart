import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/reciept_info.dart';
import 'package:one/providers/px_reciept_info.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class SelectRecieptInfoDialog extends StatelessWidget {
  const SelectRecieptInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(context.loc.selectRecieptInfo),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton.outlined(
              onPressed: () {
                Navigator.pop(context, null);
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
      scrollable: false,
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: Consumer<PxRecieptInfo>(
        builder: (context, r, _) {
          while (r.result == null) {
            return const CentralLoading();
          }

          while (r.result is ApiErrorResult) {
            final _err = (r.result as ApiErrorResult);
            return CentralError(
              code: _err.errorCode,
              toExecute: r.retry,
            );
          }

          final _data = (r.result as ApiDataResult<List<RecieptInfo>>).data;

          while (_data.isEmpty) {
            return CentralNoItems(
              message: context.loc.noRecieptInfoFound,
            );
          }

          return RadioGroup<RecieptInfo>(
            onChanged: (value) {
              if (value != null) {
                Navigator.pop(context, value);
              }
            },
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height / 2,
              width: context.isMobile
                  ? MediaQuery.sizeOf(context).width - 100
                  : MediaQuery.sizeOf(context).width / 2,
              child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final _item = _data[index];
                  return Card.outlined(
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RadioListTile(
                        title: Text(_item.title),
                        subtitle: Column(
                          spacing: 4,
                          children: [
                            Row(
                              spacing: 4,
                              children: [
                                Text(context.loc.recieptSubtitle),
                                Text(_item.subtitle),
                              ],
                            ),
                            Row(
                              spacing: 4,
                              children: [
                                Text(context.loc.recieptAddress),
                                Text(_item.address),
                              ],
                            ),
                            Row(
                              spacing: 4,
                              children: [
                                Text(context.loc.recieptPhone),
                                Text(_item.phone),
                              ],
                            ),
                            Row(
                              spacing: 4,
                              children: [
                                Text(context.loc.recieptFooter),
                                Text(_item.footer),
                              ],
                            ),
                          ],
                        ),
                        value: _item,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
