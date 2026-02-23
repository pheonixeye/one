import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/scroll_px.dart';
import 'package:provider/provider.dart';

import '../pages/shell_page/pages/app_page/pages/settings_page/widgets/language_btn.dart';

Map<int, String> scrollPositions(BuildContext context) => {
  0: context.loc.home,
  1: context.loc.features,
  7: context.loc.pricing,
  11: context.loc.faq,
  18: context.loc.contact,
};

class ResponsiveFab extends StatelessWidget {
  const ResponsiveFab({super.key});

  @override
  Widget build(BuildContext context) {
    if (!context.isMobile) {
      return const LanguageBtn();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 80),
          Consumer<PxScroll>(
            builder: (context, s, _) {
              return PopupMenuButton<String>(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(),
                ),
                itemBuilder: (context) {
                  return [
                    ...scrollPositions(context).entries.map((x) {
                      return PopupMenuItem(
                        onTap: () {
                          s.scrollToIndex(x.key);
                        },
                        child: Text(x.value),
                      );
                    }),
                  ];
                },
                child: const FloatingActionButton.small(
                  heroTag: "navigation-btn",
                  onPressed: null,
                  child: Icon(Icons.menu),
                ),
              );
            },
          ),
          const Spacer(),
          Consumer<PxScroll>(
            builder: (context, s, _) {
              return FloatingActionButton.small(
                heroTag: "scroll-to-top",
                onPressed: () {
                  s.scrollToIndex(0);
                },
                child: const Icon(Icons.navigation),
              );
            },
          ),
          const SizedBox(height: 10),
          const LanguageBtn(),
        ],
      ),
    );
  }
}
