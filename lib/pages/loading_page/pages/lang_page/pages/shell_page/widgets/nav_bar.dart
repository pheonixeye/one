import 'package:one/constants/app_business_constants.dart';
import 'package:one/models/blob_file.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/nav_bar_menu_btn.dart';
import 'package:one/providers/px_blobs.dart';
import 'package:one/providers/px_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/router/router.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxNotifications, PxLocale>(
      builder: (context, n, l, _) {
        return AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
            mouseCursor: context.isMobile ? null : SystemMouseCursors.click,
            onTap: context.isMobile
                ? null
                : () {
                    GoRouter.of(context).go("/${l.lang}/${AppRouter.app}");
                  },
            child: Row(
              children: [
                SizedBox(width: context.isMobile ? 10 : 50),
                Consumer<PxBlobs>(
                  builder: (context, b, _) {
                    while (b.result == null) {
                      return const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      );
                    }
                    while (b.files[BlobNames.app_logo.toString()] == null ||
                        b.files[BlobNames.app_logo.toString()]!.isEmpty) {
                      return Image.asset(AppAssets.icon, width: 40, height: 40);
                    }
                    return Image.memory(
                      b.files[BlobNames.app_logo.toString()]!,
                      width: 40,
                      height: 40,
                    );
                  },
                ),
                const SizedBox(width: 20),
                const Text.rich(
                  TextSpan(
                    text: String.fromEnvironment('APPLICATION_NAME'),
                    children: [
                      TextSpan(text: '\n', style: TextStyle(fontSize: 8)),
                      TextSpan(
                        text: 'v${AppBusinessConstants.ALLEVIA_VERSION}',
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const NavBarMenuBtn(),
                const SizedBox(width: 10),
              ],
            ),
          ),
          actions: context.isMobile
              ? [
                  Builder(
                    builder: (context) {
                      return IconButton.outlined(
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: const Icon(Icons.menu),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                ]
              : [],
        );
      },
    );
  }
}
