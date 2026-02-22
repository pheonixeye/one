import 'package:one/extensions/number_translator.dart';
import 'package:one/models/subscriptions/subscription.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_subscription.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class SubscriptionDetailsCard extends StatelessWidget {
  const SubscriptionDetailsCard({super.key, required this.sub});
  final SubscriptionExpanded sub;

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxSubscription, PxLocale>(
      builder: (context, a, s, l, _) {
        while (a.constants == null) {
          return Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Row(
                  spacing: 8,
                  children: [
                    const SmBtn(),
                    Text.rich(
                      TextSpan(
                        text: l.isEnglish ? sub.plan.name_en : sub.plan.name_ar,
                        children: [
                          TextSpan(
                            text:
                                ' - (${sub.plan.duration_in_days.toString().toArabicNumber(context)}) ${context.loc.days}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 50.0,
                  ),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: context.loc.activationDate,
                          children: [
                            TextSpan(text: ' : '),
                            TextSpan(
                              text: DateFormat(
                                'dd / MM / yyyy',
                                l.lang,
                              ).format(sub.start_date_parsed),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: context.loc.expiryDate,
                          children: [
                            TextSpan(text: ' : '),
                            TextSpan(
                              text: DateFormat(
                                'dd / MM / yyyy',
                                l.lang,
                              ).format(sub.end_date_parsed),
                            ),

                            if (sub.has_one_month_to_expiry) ...[
                              TextSpan(text: ' - '),
                              WidgetSpan(
                                child: const Icon(
                                  Icons.info,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: context.loc.doctorAccounts,
                          children: [
                            TextSpan(text: ' : '),
                            TextSpan(
                              text: sub.number_of_doctors
                                  .toString()
                                  .toArabicNumber(context),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: context.loc.paidVia,
                          children: [
                            TextSpan(text: ' : '),
                            TextSpan(
                              text: sub.payment.paid_via,
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: context.loc.amountInPounds,
                          children: [
                            TextSpan(text: ' : '),
                            TextSpan(
                              text: sub.payment.paid_amount
                                  .toString()
                                  .toArabicNumber(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
