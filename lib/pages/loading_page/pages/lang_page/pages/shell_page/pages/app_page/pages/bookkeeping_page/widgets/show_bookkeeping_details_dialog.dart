import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class ShowBookkeepingDetailsDialog extends StatelessWidget {
  const ShowBookkeepingDetailsDialog({
    super.key,
    required this.items,
    required this.from,
    required this.to,
  });
  final List<BookkeepingItem> items;
  final DateTime from;
  final DateTime to;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade50,
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.loc.bookkeepingBalance,
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
      scrollable: true,
      content: Consumer<PxLocale>(
        builder: (context, l, _) {
          return Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.loc.durationBalance),
              Text(
                '${context.loc.from} : ${DateFormat('dd - MM - yyyy', l.lang).format(from)}',
              ),
              Text(
                '${context.loc.to} : ${DateFormat('dd - MM - yyyy', l.lang).format(to)}',
              ),
              Builder(
                builder: (context) {
                  double _expenses = 0;
                  for (var item in items) {
                    if (item.amount.isNegative) {
                      _expenses = _expenses + item.amount;
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(context.loc.totalExpenses),
                      Text(
                        '($_expenses) ${context.loc.egp}'.toArabicNumber(
                          context,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Builder(
                builder: (context) {
                  double _income = 0;
                  for (var item in items) {
                    if (!item.amount.isNegative) {
                      _income = _income + item.amount;
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(context.loc.totalIncome),
                      Text(
                        '($_income) ${context.loc.egp}'.toArabicNumber(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Builder(
                builder: (context) {
                  double _balance = 0;
                  for (var item in items) {
                    _balance = _balance + item.amount;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(context.loc.netBalance),
                      Text(
                        '($_balance) ${context.loc.egp}'.toArabicNumber(
                          context,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
