import 'package:one/router/router.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/models/visit_data/visit_data_nav_item.dart';

class VisitDataPage extends StatefulWidget {
  const VisitDataPage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<VisitDataPage> createState() => _VisitDataPageState();
}

class _VisitDataPageState extends State<VisitDataPage> {
  bool _isExtended = false;
  late final _items = VisitDataNavItem.items(context);
  final ValueNotifier<double> _dragY = ValueNotifier(0);
  final _dragThreshold = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          _dragY.value += details.delta.dy;
        },
        onVerticalDragEnd: (details) {
          //todo: test vertical drag down
          if (_dragY.value.abs() >= _dragThreshold) {
            GoRouter.of(context).goNamed(
              AppRouter.app,
              pathParameters: defaultPathParameters(context),
            );
          } else {
            _dragY.value = 0;
          }
        },
        child: Row(
          children: [
            if (!context.isMobile)
              NavigationRail(
                useIndicator: true,
                indicatorColor: Colors.amber.shade200,
                elevation: 6,
                backgroundColor: Colors.blue.shade200,
                extended: _isExtended,
                destinations: _items.map((e) {
                  return NavigationRailDestination(
                    icon: e.icon,
                    selectedIcon: e.selectedIcon,
                    label: Text(e.title),
                  );
                }).toList(),
                selectedIndex: widget.navigationShell.currentIndex,
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
            Expanded(child: widget.navigationShell),
          ],
        ),
      ),
      bottomNavigationBar: context.isMobile
          ? BottomNavigationBar(
              useLegacyColorScheme: false,
              currentIndex: widget.navigationShell.currentIndex,
              type: BottomNavigationBarType.shifting,
              elevation: 6,
              mouseCursor: SystemMouseCursors.click,
              showSelectedLabels: true,
              items: _items
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: e.icon,
                      activeIcon: e.selectedIcon,
                      label: e.title,
                    ),
                  )
                  .toList(),
              onTap: (value) {
                widget.navigationShell.goBranch(value);
              },
            )
          : null,
    );
  }
}
