import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/router/router.dart';
import 'package:provider/provider.dart';

class ThankyouPage extends StatelessWidget {
  const ThankyouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PxLocale>(
        builder: (context, l, _) {
          // ignore: no_leading_underscores_for_local_identifiers
          final Alignment _alignment = l.isEnglish
              ? Alignment.topLeft
              : Alignment.topRight;
          return Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(AppAssets.bgSvg, fit: BoxFit.cover),
              Align(
                alignment: _alignment,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(AppAssets.icon, width: 50, height: 50),
                      const SizedBox(width: 10),
                      const Text(
                        String.fromEnvironment('APPLICATION_NAME'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Text(
                    context.loc.thankyouForRegistering,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      context.loc.verificationEmailSent,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      GoRouter.of(context).goNamed(
                        AppRouter.login,
                        pathParameters: defaultPathParameters(context),
                      );
                    },
                    label: Text(context.loc.login),
                    icon: const Icon(Icons.login),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      context.loc.professionalMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${context.loc.allRightsReserved} ${DateFormat('yyyy', l.lang).format(DateTime.now())}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
