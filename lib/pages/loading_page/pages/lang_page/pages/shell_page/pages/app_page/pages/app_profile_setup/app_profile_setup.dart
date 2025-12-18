import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/logic/grid_model.dart';
import 'package:one/router/router.dart';
import 'package:provider/provider.dart';

class AppProfileSetup extends StatelessWidget {
  const AppProfileSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PxAppConstants>(
        builder: (context, a, _) {
          while (a.constants == null) {
            return CentralLoading();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.profileSetup),
                  ),
                  subtitle: const Divider(),
                ),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.isMobile ? 2 : 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  padding: EdgeInsets.all(8),
                  children: [
                    ...gridModelList(context).map((e) {
                      return Card.outlined(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white.withValues(alpha: 0.4),
                        shadowColor: Colors.transparent,
                        elevation: 6,
                        child: InkWell(
                          onTap: () async {
                            //@permission
                            final _perm = context
                                .read<PxAuth>()
                                .isActionPermitted(
                                  PermissionEnum.User_AccountSettings_Read,
                                  context,
                                );
                            if (!_perm.isAllowed) {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return NotPermittedDialog(
                                    permission: _perm.permission,
                                  );
                                },
                              );
                              return;
                            }
                            GoRouter.of(context).goNamed(
                              e.path,
                              pathParameters: defaultPathParameters(context),
                            );
                          },
                          hoverColor: Colors.amber.shade100,
                          splashColor: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                          mouseCursor: SystemMouseCursors.click,
                          child: GridTile(
                            footer: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                e.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image(image: AssetImage(e.asset)),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
