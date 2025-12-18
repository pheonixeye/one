import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:flutter/material.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class ChangePasswordBtn extends StatelessWidget {
  const ChangePasswordBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return SmBtn(
      onPressed: () async {
        await shellFunction(
          context,
          toExecute: () async {
            await context.read<PxAuth>().changePassword();
            if (context.mounted) {
              showIsnackbar(context.loc.passwordResetEmailSent);
            }
          },
        );
      },
      child: Consumer<PxLocale>(
        builder: (context, l, _) {
          return const Icon(Icons.password);
        },
      ),
    );
  }
}
