import 'package:flutter/material.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';

class LoginRegisterAvatar extends StatelessWidget {
  const LoginRegisterAvatar({super.key, required this.alignment});
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Hero(
            tag: 'login-register-avatar',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage(AppAssets.registerAvatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: alignment,
              child: Text.rich(
                TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      text: context.loc.heroTitle,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: context.loc.heroSubtitle,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
