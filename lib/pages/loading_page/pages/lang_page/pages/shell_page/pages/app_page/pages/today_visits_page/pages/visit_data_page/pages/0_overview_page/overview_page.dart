import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';

class VisitOverviewPage extends StatelessWidget {
  const VisitOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            const Icon(FontAwesomeIcons.notEqual),
            Text(
              context.loc.availableOnlyOnLargeScreens,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return const Placeholder();
  }
}
