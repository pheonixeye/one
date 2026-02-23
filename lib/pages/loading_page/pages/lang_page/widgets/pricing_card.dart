import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/homepage_models/subscription_model.dart';
import 'package:one/providers/pricing_px.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class PricingCard extends StatelessWidget {
  const PricingCard({
    super.key,
    required this.subscription,
    required this.index,
  });
  final Subscription subscription;
  final int index;
  @override
  Widget build(BuildContext context) {
    //todo: RESPONSIVE
    return Padding(
      padding: index == 1
          ? const EdgeInsets.only(bottom: 16, left: 8, right: 8)
          : const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: context.isMobile
            ? MediaQuery.sizeOf(context).width * 0.65
            : MediaQuery.sizeOf(context).width * 0.35,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          elevation: index == 1 ? 12 : 6,
          color: index == 1 ? Colors.amber.shade300 : null,
          child: Consumer2<PxLocale, PxPricing>(
            builder: (context, l, p, _) {
              return Column(
                children: [
                  Text(
                    l.isEnglish ? subscription.titleEn : subscription.titleAr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Divider(),
                  Text(
                    l.isEnglish
                        ? subscription.descriptionEn
                        : subscription.descriptionAr,
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  Text(
                    p.isMonthly
                        ? "${subscription.monthlyFees} ${context.loc.egp} ${context.loc.monthly}"
                        : "${subscription.yearlyFees} ${context.loc.egp} ${context.loc.yearly}",
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  ...allFeatures.map((x) {
                    return Column(
                      children: [
                        subscription.features.contains(x)
                            ? const Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                        const Divider(),
                      ],
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        //TODO: nav to create account.
                      },
                      label: Text(
                        "${context.loc.try_} ${l.isEnglish ? subscription.titleEn : subscription.titleAr}",
                      ),
                      icon: index == 1
                          ? const Icon(Icons.star_rate_rounded)
                          : null,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
