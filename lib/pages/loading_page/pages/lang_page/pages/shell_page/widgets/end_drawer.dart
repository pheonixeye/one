import 'package:one/providers/px_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/drawer_nav_btn.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/thin_divider.dart';
import 'package:one/router/router.dart';
import 'package:provider/provider.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8.0,
      width: MediaQuery.sizeOf(context).width * 0.65,
      backgroundColor: Colors.blue.shade500.withValues(alpha: 0.9),
      child: Consumer2<GoRouteInformationProvider, PxAuth>(
        builder: (context, r, auth, _) {
          bool selected(String path) => r.value.uri.path.endsWith('/$path');
          // print(r.value.uri.path);
          return ListView(
            children: [
              if (context.isMobile)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      CircleAvatar(child: Icon(Icons.account_box)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            while (auth.user == null) {
                              return SizedBox(
                                height: 10,
                                child: LinearProgressIndicator(),
                              );
                            }
                            return Text(
                              '${auth.user?.email}',
                              style: TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          return IconButton(
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Scaffold.of(context).closeEndDrawer();
                            },
                            icon: const Icon(Icons.arrow_forward),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.dashboard,
                icondata: FontAwesomeIcons.gauge,
                routePath: AppRouter.app,
                selected: selected(AppRouter.app),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.clinics,
                icondata: FontAwesomeIcons.houseChimneyMedical,
                routePath: AppRouter.clinics,
                selected: selected(AppRouter.clinics),
              ),
              //todo: add when done
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.doctorAccounts,
                icondata: FontAwesomeIcons.userDoctor,
                routePath: AppRouter.doctors,
                selected: selected(AppRouter.doctors),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.patientMovementProgress,
                icondata: FontAwesomeIcons.barsProgress,
                routePath: AppRouter.clinics_patients_movements,
                selected: selected(AppRouter.clinics_patients_movements),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.forms,
                icondata: Icons.edit_document,
                routePath: AppRouter.forms,
                selected: selected(AppRouter.forms),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.supplyItemsMovement,
                icondata: Icons.warehouse,
                routePath: AppRouter.inventory_supplies,
                selected: selected(AppRouter.inventory_supplies),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.assistantAccounts,
                icondata: FontAwesomeIcons.personHalfDress,
                routePath: AppRouter.assistants,
                selected: selected(AppRouter.assistants),
              ),
              //HACK: LATER

              // const ThinDivider(),
              // DrawerNavBtn(
              //   title: context.loc.mySubscription,
              //   icondata: Icons.receipt_long,
              //   routePath: AppRouter.mysubscription,
              //   selected: selected(AppRouter.mysubscription),
              // ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.notifications,
                icondata: Icons.notifications,
                routePath: AppRouter.notifications,
                selected: selected(AppRouter.notifications),
              ),
              const ThinDivider(),
              DrawerNavBtn(
                title: context.loc.settings,
                icondata: Icons.settings,
                routePath: AppRouter.settings,
                selected: selected(AppRouter.settings),
              ),
              const ThinDivider(),
            ],
          );
        },
      ),
    );
  }
}
