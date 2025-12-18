import 'package:one/router/router.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with SingleTickerProviderStateMixin {
  bool _isExtended = false;

  late final _navDestinationItems = <NavigationRailDestination>[
    NavigationRailDestination(
      icon: const Icon(Icons.perm_contact_calendar_outlined),
      selectedIcon: const Icon(Icons.perm_contact_calendar),
      label: Text(context.loc.todayVisits),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.person),
      selectedIcon: const Icon(FontAwesomeIcons.personCirclePlus),
      label: Text(context.loc.patients),
    ),
    NavigationRailDestination(
      icon: const Icon(FontAwesomeIcons.hospitalUser),
      selectedIcon: const Icon(FontAwesomeIcons.wheelchair),
      label: Text(context.loc.visits),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.monetization_on),
      selectedIcon: const Icon(FontAwesomeIcons.moneyCheck),
      label: Text(context.loc.bookkeeping),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.settings),
      selectedIcon: const Icon(Icons.settings_suggest),
      label: Text(context.loc.profileSetup),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (!context.isMobile)
            Visibility(
              visible: !AppRouter.router.isInVisitDataPage,
              child: NavigationRail(
                useIndicator: true,
                indicatorColor: Colors.amber.shade300,
                elevation: 6,
                backgroundColor: Colors.blue.shade300,
                extended: _isExtended,
                destinations: _navDestinationItems,
                selectedIndex: widget.navigationShell.currentIndex,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.amber.shade200,
                    child:
                        _navDestinationItems[widget
                                .navigationShell
                                .currentIndex]
                            .selectedIcon,
                  ),
                ),
                onDestinationSelected: (value) {
                  widget.navigationShell.goBranch(value);
                  setState(() {
                    _isExtended = false;
                  });
                },
                trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmBtn(
                    onPressed: () {
                      setState(() {
                        _isExtended = !_isExtended;
                      });
                    },
                    child: Icon(
                      _isExtended ? Icons.arrow_back : Icons.arrow_forward,
                    ),
                  ),
                ),
              ),
            ),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: context.isMobile
          ? Builder(
              builder: (context) {
                return Visibility(
                  visible: !AppRouter.router.isInVisitDataPage,
                  child: BottomNavigationBar(
                    useLegacyColorScheme: false,
                    currentIndex: widget.navigationShell.currentIndex,
                    type: BottomNavigationBarType.shifting,
                    elevation: 6,
                    mouseCursor: SystemMouseCursors.click,
                    showSelectedLabels: true,
                    onTap: (value) {
                      widget.navigationShell.goBranch(value);
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.perm_contact_calendar_outlined),
                        activeIcon: const Icon(Icons.perm_contact_calendar),
                        label: context.loc.todayVisits,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(FontAwesomeIcons.hospitalUser),
                        activeIcon: const Icon(FontAwesomeIcons.wheelchair),
                        label: context.loc.patients,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.person),
                        activeIcon: const Icon(
                          FontAwesomeIcons.personCirclePlus,
                        ),
                        label: context.loc.visits,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.monetization_on),
                        activeIcon: const Icon(FontAwesomeIcons.moneyCheck),
                        label: context.loc.bookkeeping,
                      ),
                      BottomNavigationBarItem(
                        tooltip: context.loc.profileSetup,
                        icon: const Icon(Icons.settings),
                        activeIcon: const Icon(Icons.settings_suggest),
                        label: context.loc.profileSetup,
                      ),
                    ],
                  ),
                );
              },
            )
          : null,
    );
  }
}
