import 'package:flutter/material.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/models/homepage_models/feature_model.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/selective_intrinsic.dart';
import 'package:provider/provider.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.index,
    required this.feature,
    this.isDark = false,
  });
  final int index;
  final Feature feature;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? 10 : 50,
        vertical: 10,
      ),
      child: Card(
        color: Color(feature.color),
        elevation: 6,
        child: Consumer<PxLocale>(
          builder: (context, l, _) {
            return SelectiveIntrinsic(
              child: Flex(
                direction: context.isMobile ? Axis.vertical : Axis.horizontal,
                children: [
                  if (context.isMobile) const SizedBox(height: 10),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.isEnglish ? feature.titleEn : feature.titleAr,
                            style: TextStyle(
                              color: isDark ? Colors.black : Colors.white,
                              fontSize: context.isMobile ? 32 : 58,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l.isEnglish
                                ? feature.descriptionEn
                                : feature.descriptionAr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      AppAssets.featureImage(index),
                      fit: BoxFit.contain,
                      height: context.isMobile ? 150 : 400,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
