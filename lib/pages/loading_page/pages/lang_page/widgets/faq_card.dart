import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/models/homepage_models/faq_model.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class FaqCard extends StatelessWidget {
  const FaqCard({super.key, required this.faq});
  final Faq faq;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? 10 : 50,
        vertical: 10,
      ),
      child: Consumer<PxLocale>(
        builder: (context, l, _) {
          return ExpansionTile(
            leading: const SmBtn(),
            title: Text(l.isEnglish ? faq.qEn : faq.qAr),
            backgroundColor: Colors.amber.shade100.withValues(alpha: 0.7),
            childrenPadding: const EdgeInsets.all(8),
            children: [
              Text(
                l.isEnglish ? faq.aEn : faq.aAr,
                textAlign: TextAlign.start,
              ),
            ],
          );
        },
      ),
    );
  }
}
