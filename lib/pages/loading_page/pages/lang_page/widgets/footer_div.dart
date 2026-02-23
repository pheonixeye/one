import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/widgets/nav_list_btns.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/how_it_works_dialog.dart';

class FooterDiv extends StatelessWidget {
  const FooterDiv({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.blue.shade300,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Spacer(),
              Image.asset(
                AppAssets.icon,
                height: 50,
              ),
              const SizedBox(width: 20),
              const Text(
                String.fromEnvironment('APPLICATION_NAME'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).goNamed(
                    AppRouter.login,
                    pathParameters: defaultPathParameters(context),
                  );
                },
                child: Text(context.loc.getStarted),
              ),
              const SizedBox(width: 20),
              Text(
                context.loc.learnMore,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
            ],
          ),
          const NavListBtns(inFooter: true),
          Row(
            children: [
              const Spacer(),
              Text.rich(
                TextSpan(
                  text: context.loc.legal,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const HowItWorksDialog(),
                      );
                    },
                  children: [
                    const TextSpan(text: ' '),
                    const TextSpan(text: '@one.ProKliniK.app'),
                    const TextSpan(text: ' '),
                    TextSpan(text: "${DateTime.now().year}"),
                  ],
                ),
              ),
              const SizedBox(width: 100),
            ],
          ),
        ],
      ),
    );
  }
}
