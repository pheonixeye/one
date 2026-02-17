import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/monthly_visits_calendar_dialog.dart';
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
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(context.loc.visitsCalender),
                  titleAlignment: ListTileTitleAlignment.top,
                  onTap: () async {
                    await showGeneralDialog<void>(
                      context: context,
                      pageBuilder: (context, a1, a2) {
                        return MonthlyVisitsCalendarDialog();
                      },
                      anchorPoint: Offset(100, 100),
                      transitionDuration: const Duration(milliseconds: 600),
                      transitionBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              alignment: Alignment.topLeft,
                              scale: animation,
                              child: child,
                            );
                          },
                    );
                  },
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                child: PopupMenuButton<void>(
                  offset: l.isEnglish ? Offset(-200, 25) : Offset(200, 25),
                  elevation: 6,
                  // icon: const Icon(Icons.settings),
                  shadowColor: Colors.transparent,
                  color: Colors.amber.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.add),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(context.loc.addNewNotification),
                          ),
                          onTap: () async {},
                        ),
                      ),
                      PopupMenuDivider(),
                    ];
                  },
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.top,
                    leading: const Icon(Icons.notification_add),
                    title: Text(context.loc.notifications),
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
