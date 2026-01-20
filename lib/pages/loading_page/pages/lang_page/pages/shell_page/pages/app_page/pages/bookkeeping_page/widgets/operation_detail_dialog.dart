import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/extensions/size_ext.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/models/bookkeeping/bookkeeping_name.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/previous_visit_view_card.dart';
import 'package:one/providers/px_bookkeeping.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_one_visit.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OperationDetailDialog extends StatelessWidget {
  const OperationDetailDialog({super.key, required this.visit_id});
  final String visit_id;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.loc.operationsDetails,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: Consumer3<PxBookkeeping, PxOneVisit, PxLocale>(
        builder: (context, b, v, l, _) {
          while (b.result == null || v.result == null) {
            return CentralLoading();
          }
          while (b.result is ApiErrorResult || v.result is ApiErrorResult) {
            return CentralError(
              code: (b.result as ApiErrorResult).errorCode,
              toExecute: () async {
                await b.retry();
                await v.retry();
              },
            );
          }
          final _visit = (v.result as ApiDataResult<VisitExpanded>).data;
          final _data = (b.result as ApiDataResult<List<BookkeepingItem>>).data;
          final _bk_items = _data.where((e) => e.visit_id == visit_id).toList();
          return SizedBox(
            width: context.screenWidth,
            height: context.screenHeight,
            child: ListView(
              children: [
                PreviousVisitViewCard(
                  item: _visit,
                  index: 0,
                  showPatientName: true,
                  showIndexNumber: false,
                ),
                const Divider(),
                ..._bk_items.map((bk) {
                  final _index = _data.indexOf(bk);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card.outlined(
                      color: _buildCardColor(bk.amount),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          titleAlignment: ListTileTitleAlignment.titleHeight,
                          leading: SmBtn(
                            onPressed: null,
                            child: Text('${_index + 1}'),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l.isEnglish
                                      ? bk.item_name
                                      : BookkeepingName.fromString(
                                          bk.item_name,
                                        ).tryTranslate(),
                                ),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: context.loc.amount,
                                    children: [
                                      TextSpan(text: ' : '),
                                      TextSpan(
                                        text: '(${bk.amount})'.toArabicNumber(
                                          context,
                                        ),
                                      ),
                                      TextSpan(text: ' '),
                                      TextSpan(text: context.loc.egp),
                                    ],
                                  ),
                                ),
                              ),
                              if (!context.isMobile) const Spacer(),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: context.loc.date,
                                    children: [
                                      TextSpan(text: ' : '),
                                      if (context.isMobile)
                                        TextSpan(text: '\n'),
                                      TextSpan(
                                        text: DateFormat(
                                          'dd - MM - yyyy',
                                          l.lang,
                                        ).format(bk.created.toLocal()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: context.loc.operationTime,
                                    children: [
                                      TextSpan(text: ' : '),
                                      if (context.isMobile)
                                        TextSpan(text: '\n'),
                                      TextSpan(
                                        text: DateFormat(
                                          'h:mm a',
                                          l.lang,
                                        ).format(bk.created.toLocal()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: context.loc.addedBy,
                                    children: [
                                      TextSpan(text: ' : '),
                                      if (context.isMobile)
                                        TextSpan(text: '\n'),
                                      TextSpan(text: bk.added_by),
                                    ],
                                  ),
                                ),
                              ),
                              if (!context.isMobile) const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _buildCardColor(double value) {
    return switch (value) {
      0 => Colors.white,
      > 0 => Colors.green.shade50,
      < 0 => Colors.red.shade50,
      _ => Colors.white,
    };
  }
}
