import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/end_drawer.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/nav_bar.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Row(
        children: [
          if (!context.isMobile) const Expanded(flex: 1, child: EndDrawer()),
          Expanded(flex: 3, child: child),
        ],
      ),
      endDrawer: context.isMobile ? const EndDrawer() : null,
    );
  }
}
