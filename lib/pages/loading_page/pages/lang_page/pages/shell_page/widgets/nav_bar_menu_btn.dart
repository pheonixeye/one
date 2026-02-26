import 'package:flutter/cupertino.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/app_constants/account_type.dart';
import 'package:one/models/notifications/assistant_clinic_calls.dart';
import 'package:one/models/notifications/doctor_clinic_call.dart';
import 'package:one/models/user/user.dart';
import 'package:one/providers/px_assistant_accounts.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarMenuBtn extends StatelessWidget {
  const NavBarMenuBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<PxAuth, PxDoctor, PxAssistantAccounts, PxLocale>(
      builder: (context, auth, d, a, l, _) {
        while (d.allDoctors == null || a.users == null) {
          return const SizedBox(
            width: 40,
            height: 40,
            child: CupertinoActivityIndicator(),
          );
        }
        final _doctors = d.allDoctorsAuth;
        final _assistants = (a.users as ApiDataResult<List<User>>).data;
        final _doctorsWithAll = _doctors != null
            ? <User>[
                ..._doctors,
                User(
                  id: 'all',
                  email: '',
                  name: l.isEnglish ? 'All Doctors' : 'كل الاطباء',
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
              ]
            : [];

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
                child: PopupMenuButton<void>(
                  offset: l.isEnglish ? Offset(-100, 50) : Offset(100, 50),
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(),
                  ),
                  itemBuilder: (context) {
                    return !auth.isUserNotDoctor
                        ? [
                            ..._assistantsWithAll.map((e) {
                              return PopupMenuItem<void>(
                                padding: const EdgeInsets.all(0),
                                child: PopupMenuButton(
                                  offset: l.isEnglish
                                      ? Offset(-150, 25)
                                      : Offset(150, 25),
                                  elevation: 6,
                                  borderRadius: BorderRadius.circular(12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(),
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      ...DoctorClinicCall.values.map((
                                        e,
                                      ) {
                                        return PopupMenuItem(
                                          child: ListTile(
                                            titleAlignment:
                                                ListTileTitleAlignment.top,
                                            leading: Icon(
                                              e.iconData,
                                              color: Colors.black,
                                            ),
                                            title: Text(
                                              l.isEnglish ? e.en : e.ar,
                                            ),
                                          ),
                                          onTap: () {
                                            //TODO:
                                          },
                                        );
                                      }),
                                    ];
                                  },
                                  child: ListTile(
                                    titleAlignment: ListTileTitleAlignment.top,
                                    leading: const Icon(
                                      Icons.notification_important_outlined,
                                      color: Colors.black,
                                    ),
                                    title: Text(e.name),
                                  ),
                                ),
                              );
                            }),
                          ]
                        : [
                            if (_doctors != null)
                              ..._doctorsWithAll.map((e) {
                                return PopupMenuItem<User>(
                                  child: PopupMenuButton(
                                    offset: l.isEnglish
                                        ? Offset(-150, 25)
                                        : Offset(150, 25),

                                    elevation: 6,
                                    borderRadius: BorderRadius.circular(12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                      side: BorderSide(),
                                    ),
                                    itemBuilder: (context) {
                                      return [
                                        ...AssistantClinicCalls.values.map((
                                          e,
                                        ) {
                                          return PopupMenuItem(
                                            child: ListTile(
                                              titleAlignment:
                                                  ListTileTitleAlignment.top,
                                              leading: Icon(
                                                e.iconData,
                                                color: Colors.black,
                                              ),
                                              title: Text(
                                                l.isEnglish ? e.en : e.ar,
                                              ),
                                            ),
                                            onTap: () {
                                              //TODO:
                                            },
                                          );
                                        }),
                                      ];
                                    },
                                    child: ListTile(
                                      titleAlignment:
                                          ListTileTitleAlignment.top,
                                      leading: const Icon(
                                        Icons.notification_important_outlined,
                                        color: Colors.black,
                                      ),
                                      title: Text(e.name),
                                    ),
                                  ),
                                );
                              }),
                          ];
                  },
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.top,
                    leading: const Icon(Icons.settings_voice),
                    title: Text(context.loc.clinicCalls),
                  ),
                ),
              ),
            ];
          },
        );
      },
    );
  }
}
