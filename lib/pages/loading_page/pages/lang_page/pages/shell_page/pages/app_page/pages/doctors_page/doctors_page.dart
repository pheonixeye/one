import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/doctors_page/widgets/doctor_account_card.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/not_permitted_template_page.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorsPage extends StatelessWidget {
  const DoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxDoctor, PxLocale>(
      builder: (context, d, l, _) {
        //@permission
        final _isSuperAdmin = PxAuth.isLoggedInUserSuperAdmin(context);

        while (!_isSuperAdmin) {
          return NotPermittedTemplatePage(title: context.loc.doctorAccounts);
        }
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.doctorAccounts),
                  ),
                  subtitle: const Divider(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (d.allDoctors == null) {
                      return const CentralLoading();
                    }

                    while (d.allDoctors is ApiErrorResult) {
                      return CentralError(
                        code: (d.allDoctors as ApiErrorResult).errorCode,
                        toExecute: d.retry,
                      );
                    }
                    while (d.allDoctors != null && d.allDoctors!.isEmpty) {
                      return Center(
                        child: Card.outlined(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(context.loc.noDoctorsFound),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: d.allDoctors!.length,
                      itemBuilder: (context, index) {
                        final item = d.allDoctors![index];
                        return DoctorAccountCard(doctor: item, index: index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: SmBtn(
            tooltip: context.loc.addNewDoctorAccount,
            onPressed: () async {
              //TODO: show dialog to contact account manager
              // final _doc = await showDialog(
              //   context: context,
              //   builder: (context) {
              //     return const AddDoctorAccountDialog();
              //   },
              // );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
