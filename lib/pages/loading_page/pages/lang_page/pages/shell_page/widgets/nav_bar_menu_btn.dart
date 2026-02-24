import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/clinic_call.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarMenuBtn extends StatelessWidget {
  const NavBarMenuBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return ThemedPopupmenuBtn<void>(
          icon: const Icon(Icons.notification_add),
          tooltip: context.loc.notifications,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: PopupMenuButton<void>(
                  offset: l.isEnglish ? Offset(-200, 25) : Offset(200, 25),
                  elevation: 6,
                  shadowColor: Colors.transparent,
                  color: Colors.amber.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(),
                  ),
                  itemBuilder: (context) {
                    return [
                      //TODO: formulate clinic calls notifications
                      ...ClinicCall.values.map((e) {
                        return PopupMenuItem(
                          child: Text(e.name),
                        );
                      }),
                    ];
                  },
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.top,
                    leading: const Icon(Icons.settings_voice),
                    title: Text(context.loc.clinicCalls),
                  ),
                ),
              ),
            ];
          },
        );
      },
    );
  }
}
