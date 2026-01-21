import 'package:flutter/material.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class OrganizationIsInactive extends StatelessWidget {
  const OrganizationIsInactive({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Text(
              context.loc.subscriptionExpiredTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              AppAssets.subscription_expired(l.lang),
              alignment: Alignment.center,
            ),
            const Divider(),
            Text(
              context.loc.subscriptionExpiredSubtitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              context.loc.subscriptionExpiredMessage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              context.loc.subscriptionExpiredContact,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(),
            ElevatedButton.icon(
              onPressed: () {
                web.window.open('tel://+201555905768', '_blank');
              },
              label: Text(
                context.loc.contactSupport,
              ),
              icon: const Icon(Icons.call),
            ),
          ],
        );
      },
    );
  }
}
