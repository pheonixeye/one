import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/switch_lang.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class LanguageBtn extends StatelessWidget {
  const LanguageBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return SmBtn(
      onPressed: () {
        context.switchLanguage();
      },
      child: Consumer<PxLocale>(
        builder: (context, l, _) {
          return Text(l.isEnglish ? 'AR' : 'EN');
        },
      ),
    );
  }
}
