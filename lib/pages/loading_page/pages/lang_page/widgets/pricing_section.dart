import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/providers/pricing_px.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class PricingSection extends StatelessWidget {
  const PricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPricing, PxLocale>(
      builder: (context, p, l, _) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Expanded(
                flex: context.isMobile ? 20 : 2,
                child: Card.outlined(
                  elevation: 6,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            spacing: 8,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text:
                                      '${(p.isMonthly ? '1500' : '1000').toArabicNumber(context)} ${context.loc.egp}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' / ${context.loc.month}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\n',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: p.isMonthly
                                          ? context.loc.billedHalfAnually
                                          : context.loc.billedAnually,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(text: ' '),
                                    TextSpan(
                                      text: p.isMonthly
                                          ? '(7500 ${context.loc.egp} / 6 ${context.loc.months})'
                                                .toArabicNumber(context)
                                          : '(12000 ${context.loc.egp} / 12 ${context.loc.months})'
                                                .toArabicNumber(context),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        const Divider(),
                        ..._pricingVAlues(context).map(
                          (e) =>
                              _FeaturePricingTile(title: e.$1, subtitle: e.$2),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              web.window.open(
                                "tel:+201555905768",
                                "Call Mobile",
                                "_blank",
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  Text(context.loc.subscribeNow),
                                  const Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}

class _FeaturePricingTile extends StatelessWidget {
  const _FeaturePricingTile({
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsetsDirectional.only(start: 40),
      leading: Icon(
        Icons.check_circle,
        color: Colors.amber.shade200,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

List<(String title, String subtitle)> _pricingVAlues(BuildContext context) => [
  (context.loc.feat_one_title, context.loc.feat_one_sub),
  (context.loc.feat_two_title, context.loc.feat_two_sub),
  (context.loc.feat_three_title, context.loc.feat_three_sub),
  (context.loc.feat_four_title, context.loc.feat_four_sub),
  (context.loc.feat_five_title, context.loc.feat_five_sub),
];
