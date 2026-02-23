import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/pricing_px.dart';
import 'package:provider/provider.dart';

class SubscriptionType extends StatefulWidget {
  const SubscriptionType({super.key});

  @override
  State<SubscriptionType> createState() => _SubscriptionTypeState();
}

class _SubscriptionTypeState extends State<SubscriptionType> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.isMobile ? 10 : 50),
      child: Consumer<PxPricing>(
        builder: (context, p, _) {
          return ListTile(
            title: Row(
              children: [
                Text(context.loc.choosePlan),
                SizedBox(width: 10),
                Expanded(
                  child: ToggleButtons(
                    isSelected: [
                      p.isMonthly,
                      p.isMonthly,
                    ],
                    onPressed: (index) {
                      p.swap();
                    },
                    children: [
                      Card.outlined(
                        elevation: p.isMonthly ? 0 : 6,
                        color: p.isMonthly ? Colors.amber.shade200 : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.loc.halfAnnual),
                        ),
                      ),
                      Card.outlined(
                        elevation: p.isMonthly ? 6 : 0,
                        color: !p.isMonthly ? Colors.amber.shade200 : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${context.loc.annual} ${!p.isMonthly ? "(${context.loc.bestValue})" : ''}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
