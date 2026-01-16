import 'package:flutter/material.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class EntryNumberColumn extends StatelessWidget {
  const EntryNumberColumn({
    super.key,
    required this.visit,
  });
  final VisitExpanded visit;
  @override
  Widget build(BuildContext context) {
    return Consumer<PxVisits>(
      builder: (context, v, _) {
        return Column(
          spacing: 12,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () async {
                //@permission
                final _perm = context.read<PxAuth>().isActionPermitted(
                  PermissionEnum.User_TodayVisits_Modify_Entry_Number,
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
                await shellFunction(
                  context,
                  toExecute: () async {
                    await v.updateVisit(
                      visit: visit,
                      key: 'patient_entry_number',
                      value: visit.patient_entry_number + 1,
                    );
                  },
                );
              },
              child: Icon(Icons.arrow_drop_up),
            ),
            SmBtn(
              onPressed: null,
              child: Text(
                '${visit.patient_entry_number}'.toArabicNumber(
                  context,
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () async {
                //@permission
                final _perm = context.read<PxAuth>().isActionPermitted(
                  PermissionEnum.User_TodayVisits_Modify_Entry_Number,
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
                if (visit.patient_entry_number <= 1) {
                  return;
                }
                await shellFunction(
                  context,
                  toExecute: () async {
                    await v.updateVisit(
                      visit: visit,
                      key: 'patient_entry_number',
                      value: visit.patient_entry_number - 1,
                    );
                  },
                );
              },
              child: Icon(Icons.arrow_drop_down),
            ),
          ],
        );
      },
    );
  }
}
