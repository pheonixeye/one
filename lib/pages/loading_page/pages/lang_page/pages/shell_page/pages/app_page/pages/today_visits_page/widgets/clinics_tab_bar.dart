import 'package:flutter/material.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class ClinicsTabBar extends StatelessWidget implements PreferredSizeWidget {
  const ClinicsTabBar({
    super.key,
    required this.clinics,
    required this.controller,
  });
  final List<Clinic> clinics;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return TabBar(
          physics: BouncingScrollPhysics(),
          isScrollable: true,
          controller: controller,
          tabAlignment: TabAlignment.center,
          tabs: [
            ...clinics.map((e) {
              return Tab(child: Text(l.isEnglish ? e.name_en : e.name_ar));
            }),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
