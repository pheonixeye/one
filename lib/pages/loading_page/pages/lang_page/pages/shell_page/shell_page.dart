import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/end_drawer.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/nav_bar.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/organization_is_inactive.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_subscription.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!context.isMobile) const Expanded(flex: 1, child: EndDrawer()),
          Expanded(
            flex: 3,
            child: Consumer2<PxAuth, PxSubscription>(
              builder: (context, auth, s, _) {
                while (auth.organization == null || s.result == null) {
                  return const CentralLoading();
                }
                final _isActive = auth.organization!.activity == 'active';
                return _isActive ? child : const OrganizationIsInactive();
              },
            ),
          ),
        ],
      ),
      endDrawer: context.isMobile ? const EndDrawer() : null,
    );
  }
}
