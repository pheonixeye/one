import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/extensions/lang_ext.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class LanguageBtn extends StatelessWidget {
  const LanguageBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        tooltip: context.loc.lang,
        heroTag: 'lang-btn',
        onPressed: () {
          late final String newPath;
          final lang =
              GoRouter.of(
                    context,
                  ).routerDelegate.currentConfiguration.pathParameters['lang']
                  as String;
          final currentPath = GoRouter.of(
            context,
          ).routerDelegate.currentConfiguration.uri.path;
          if (lang == 'en') {
            newPath = currentPath.replaceAll('/en', '/ar');
          } else {
            newPath = currentPath.replaceAll('/ar', '/en');
          }
          if (kDebugMode) {
            print("current : $currentPath");
            print("new : $newPath");
          }
          context.read<PxLocale>().setLang(lang.switchLang());
          context.read<PxLocale>().setLocale();
          GoRouter.of(context).go(newPath);
        },
        child: const Icon(Icons.language),
      ),
    );
  }
}
