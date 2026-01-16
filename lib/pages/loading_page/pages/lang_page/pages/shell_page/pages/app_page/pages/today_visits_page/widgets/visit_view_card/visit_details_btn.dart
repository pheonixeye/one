import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/app_constants/visit_status.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:provider/provider.dart';

class VisitDetailsBtn extends StatelessWidget {
  const VisitDetailsBtn({super.key, required this.visit});
  final VisitExpanded visit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SmBtn(
          onPressed: () async {
            //@permission
            final _perm = context.read<PxAuth>().isActionPermitted(
              PermissionEnum.Admin,
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
            if (visit.visit_status == VisitStatusEnum.NotAttended.en) {
              showIsnackbar(context.loc.visitNotAttended);
              return;
            }
            GoRouter.of(context).goNamed(
              AppRouter.visit_forms,
              pathParameters: defaultPathParameters(context)
                ..addAll({'visit_id': visit.id}),
              extra: visit.patient_id,
            );
          },
          child: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
