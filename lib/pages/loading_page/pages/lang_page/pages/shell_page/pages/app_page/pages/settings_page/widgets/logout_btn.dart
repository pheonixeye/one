import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxAuth>(
      builder: (context, a, _) {
        return SmBtn(
          tooltip: context.loc.logout,
          onPressed: () async {
            final _toLogout = await showDialog<bool>(
              context: context,
              builder: (context) {
                return PromptDialog(message: context.loc.logoutPrompt);
              },
            );
            if (_toLogout == null || !_toLogout) {
              return;
            }
            a.logout();
            if (context.mounted) {
              GoRouter.of(context).goNamed(
                AppRouter.login,
                pathParameters: defaultPathParameters(context),
              );
            }
          },
          child: const Icon(Icons.logout),
        );
      },
    );
  }
}
