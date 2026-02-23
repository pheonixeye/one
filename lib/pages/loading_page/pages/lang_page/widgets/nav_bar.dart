import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/widgets/nav_list_btns.dart';
import 'package:one/router/router.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Widget> _actions(BuildContext context) => context.isMobile
      ? []
      : [
          const SizedBox(width: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: () {
              //todo: login link
              GoRouter.of(context).goNamed(
                AppRouter.login,
                pathParameters: defaultPathParameters(context),
              );
            },
            label: Text(context.loc.login),
            icon: const Icon(Icons.arrow_forward),
          ),
          const SizedBox(width: 10),

          const SizedBox(width: 10),
        ];

  @override
  Widget build(BuildContext context) {
    //todo: RESPONSIVE
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width: context.isMobile ? 20 : 50),
            Expanded(
              child: Image.asset(
                AppAssets.icon,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              const String.fromEnvironment('APPLICATION_NAME'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      leadingWidth: 300,
      title: context.isMobile ? null : const NavListBtns(),
      actions: _actions(context),
    );
  }
}
