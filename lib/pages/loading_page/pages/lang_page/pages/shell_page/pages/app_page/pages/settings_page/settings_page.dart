import 'package:one/constants/app_business_constants.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/change_log_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/change_password_btn.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/files_section.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/reciept_settings/reciept_settings_section.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/single_btn_tile.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/whatsapp_tile/whatsapp_tile.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/language_btn.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/logout_btn.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(context.loc.settings),
              subtitle: const Divider(),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Consumer3<PxAuth, PxAppConstants, PxLocale>(
                  builder: (context, auth, a, l, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card.outlined(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  if (auth.user == null)
                                    SizedBox(
                                      height: 10,
                                      child: LinearProgressIndicator(),
                                    )
                                  else ...[
                                    if (PxAuth.isLoggedInUserSuperAdmin(
                                      context,
                                    ))
                                      Card.outlined(
                                        elevation: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            l.isEnglish
                                                ? a.superadmin.name_en
                                                : a.superadmin.name_ar,
                                          ),
                                        ),
                                      ),
                                    Text('${auth.user?.email}'),
                                    Text(
                                      '${l.isEnglish ? auth.user?.account_type.name_en : auth.user?.account_type.name_ar}',
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            subtitle: const Divider(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const WhatsappTile(),
                //todo: Add section for clinic / reciept info and select reciept default printing info
                const RecieptSettingsSection(),
                //todo: Manage notification sound and app logo
                const FilesSection(),

                SingleBtnTile(
                  title: context.loc.appLanguage,
                  btn: const LanguageBtn(),
                ),
                SingleBtnTile(
                  title: context.loc.changePassword,
                  btn: const ChangePasswordBtn(),
                ),
                SingleBtnTile(
                  title: context.loc.logout,
                  btn: const LogoutBtn(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  text:
                      '${const String.fromEnvironment('APPLICATION_NAME')} v${AppBusinessConstants.ALLEVIA_VERSION}',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return ChangeLogDialog();
                        },
                      );
                    },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
