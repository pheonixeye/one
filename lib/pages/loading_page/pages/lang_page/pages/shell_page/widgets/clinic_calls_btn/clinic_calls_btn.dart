import 'package:flutter/cupertino.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/app_constants/account_type.dart';
import 'package:one/models/user/user.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/clinic_calls_btn/calls_logic_btn.dart';
import 'package:one/providers/px_assistant_accounts.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_firebase_notifications.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClinicCallsBtn extends StatelessWidget {
  const ClinicCallsBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer5<
      PxAuth,
      PxDoctor,
      PxAssistantAccounts,
      PxFirebaseNotifications,
      PxLocale
    >(
      builder: (context, auth, d, a, fcm, l, _) {
        while (d.allDoctors == null || a.users == null) {
          return const SizedBox(
            width: 40,
            height: 40,
            child: CupertinoActivityIndicator(),
          );
        }
        final _doctors = d.allDoctorsAuth;
        final _assistants = (a.users as ApiDataResult<List<User>>).data;

        final _assistantsWithAll = <User>[
          ..._assistants,
          User(
            id: 'all',
            email: '',
            name: l.isEnglish ? 'All Assistants' : 'كل المساعدين',
            org_id: '',
            verified: true,
            is_active: true,
            account_type: AccountType(
              id: '',
              name_en: '',
              name_ar: '',
            ),
            app_permissions: [],
          ),
        ];
        return ThemedPopupmenuBtn<void>(
          icon: const Icon(Icons.notification_add),
          tooltip: context.loc.clinicCalls,
          borderRadius: BorderRadius.circular(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(),
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: CallsLogicBtn(
                  auth: auth,
                  assistantsWithAll: _assistantsWithAll,
                  doctors: _doctors ?? <User>[],
                  isEnglish: l.isEnglish,
                  d: d,
                  fcm: fcm,
                ),
              ),
            ];
          },
        );
      },
    );
  }
}
