import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/router/router.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    //todo: RESPONSIVE
    return Stack(
      children: [
        Transform.scale(
          scaleX: -1,
          child: Image.asset(
            AppAssets.hero,
            fit: BoxFit.cover,
            matchTextDirection: true,
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
          ),
        ),
        Positioned(
          height: MediaQuery.sizeOf(context).height,
          width: context.isMobile
              ? MediaQuery.sizeOf(context).width
              : MediaQuery.sizeOf(context).width / 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),
                SelectableText(
                  context.loc.heroTitle,
                  style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SelectableText(context.loc.heroSubtitle),
                const Spacer(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          GoRouter.of(context).goNamed(
                            AppRouter.login,
                            pathParameters: defaultPathParameters(context),
                          );
                        },
                        label: Text(
                          context.loc.getStarted,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_outward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
