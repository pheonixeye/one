import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/extensions/subscription_plan_ext.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_doc_subscription_info.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class SelectSubscriptionDialog extends StatefulWidget {
  const SelectSubscriptionDialog({super.key});

  @override
  State<SelectSubscriptionDialog> createState() =>
      _SelectSubscriptionDialogState();
}

class _SelectSubscriptionDialogState extends State<SelectSubscriptionDialog> {
  late final CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController(initialItem: 1);
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxDocSubscriptionInfo, PxLocale>(
      builder: (context, a, s, l, _) {
        while (a.constants == null || s.result == null) {
          return const CentralLoading();
        }
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text(context.loc.selectSubscription)),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          scrollable: true,
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * (0.65),
            child: CarouselView.weighted(
              controller: _carouselController,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              flexWeights: [1, 8, 1],
              children: [
                //TODO: Fix overflow issue
                ...a.validSubscriptions.map((e) {
                  return Card.outlined(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: e.getCardColor,
                    elevation: 6,
                    child: ClipRect(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              l.isEnglish ? e.name_en : e.name_ar,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: SvgPicture.asset(e.getAssetImage),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Divider(color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 16.0,
                              ),
                              child: Text(
                                '${e.price.toString()} ${context.loc.egp}'
                                    .toArabicNumber(context),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (e.savingPercent(a.monthly!.price) != 0)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 16.0,
                              ),
                              child: Card.outlined(
                                elevation: 6,
                                color: Colors.amber.shade50,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${context.loc.youSave} (${e.savingPercent(a.monthly!.price)}) %'
                                        .toArabicNumber(context),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 16.0,
                              ),
                              child: Text(
                                context.loc.vatExclusive,
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                }),
              ],
              onTap: (value) {
                Navigator.pop(context, a.validSubscriptions[value]);
              },
            ),
          ),
        );
      },
    );
  }
}
