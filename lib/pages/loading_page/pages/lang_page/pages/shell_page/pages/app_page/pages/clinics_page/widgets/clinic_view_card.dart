import 'package:one/core/api/clinics_api.dart';
import 'package:one/core/api/doctor_api.dart';
import 'package:one/core/api/kutt_api.dart';
import 'package:one/extensions/clinic_ext.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/booking_url_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/clinic_doctors_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/clinic_inventory_api.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/clinic_inventory_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/clinic_prescription_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/clinic_schedule_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/create_edit_clinic_dialog.dart';
import 'package:one/providers/px_clinic_inventory.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/themed_popupmenu_btn.dart';
import 'package:provider/provider.dart';

class ClinicViewCard extends StatelessWidget {
  const ClinicViewCard({super.key, required this.clinic, required this.index});
  final Clinic clinic;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxClinics, PxLocale>(
      builder: (context, c, l, _) {
        return Card.outlined(
          elevation: clinic.is_main ? 0 : 6,
          color: clinic.is_main ? Colors.lightBlue.shade200 : null,
          shape: clinic.is_main
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                  side: BorderSide(),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.top,
              leading: SmBtn(onPressed: null, child: Text('${index + 1}')),
              title: Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: l.isEnglish ? clinic.name_en : clinic.name_ar,
                        children: [
                          TextSpan(text: ' '),
                          TextSpan(
                            text: !clinic.is_active
                                ? l.isEnglish
                                      ? "(InActive)"
                                      : "(غير مفعلة)"
                                : '',
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: clinic.is_main
                                ? l.isEnglish
                                      ? "(Primary)"
                                      : "(الرئيسية)"
                                : '',
                          ),
                        ],
                      ),
                      style: clinic.is_active
                          ? null
                          : TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                  ),
                  SmBtn(
                    tooltip: context.loc.editClinic,
                    onPressed: () async {
                      //@permission
                      final _perm = context.read<PxAuth>().isActionPermitted(
                        PermissionEnum.User_Clinics_Modify,
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
                      final _toUpdate = await showDialog<Clinic?>(
                        context: context,
                        builder: (context) {
                          return CreateEditClinicDialog(clinic: clinic);
                        },
                      );

                      if (_toUpdate == null) {
                        return;
                      }
                      if (context.mounted) {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await c.updateClinicInfo(_toUpdate);
                          },
                        );
                      }
                    },
                    child: const Icon(Icons.edit),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: context.loc.phone,
                            children: [
                              TextSpan(text: ' : '),
                              TextSpan(
                                text: clinic.phone_number,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: context.loc.consultationFees,
                            children: [
                              TextSpan(text: ' : '),
                              TextSpan(
                                text: clinic.consultation_fees.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' '),
                              TextSpan(text: context.loc.egp),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: context.loc.followupFees,
                            children: [
                              TextSpan(text: ' : '),
                              TextSpan(
                                text: clinic.followup_fees.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' '),
                              TextSpan(text: context.loc.egp),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: context.loc.procedureFees,
                            children: [
                              TextSpan(text: ' : '),
                              TextSpan(
                                text: clinic.procedure_fees.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' '),
                              TextSpan(text: context.loc.egp),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: context.loc.followupDuration,
                            children: [
                              TextSpan(text: ' : '),
                              TextSpan(
                                text: clinic.followup_duration.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' '),
                              TextSpan(text: context.loc.days),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ThemedPopupmenuBtn<void>(
                    tooltip: context.loc.settings,
                    icon: const Icon(Icons.settings),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.electric_bolt),
                              Text(context.loc.toogleClinicActivity),
                            ],
                          ),
                          onTap: () async {
                            //@permission
                            final _perm = context
                                .read<PxAuth>()
                                .isActionPermitted(
                                  PermissionEnum.User_Clinics_Activity,
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
                                await c.toggleClinicActivation(clinic);
                              },
                            );
                          },
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              Text(context.loc.clinicSchedule),
                            ],
                          ),
                          onTap: () async {
                            //@permission
                            final _perm = context
                                .read<PxAuth>()
                                .isActionPermitted(
                                  PermissionEnum.User_Clinics_Schedule,
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
                            c.selectClinic(clinic);
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return ChangeNotifierProvider.value(
                                  value: c,
                                  child: ClinicScheduleDialog(),
                                );
                              },
                            ).whenComplete(() {
                              c.selectClinic(null);
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.edit_document),
                              Text(context.loc.clinicPrescription),
                            ],
                          ),
                          onTap: () async {
                            //@permission
                            final _perm = context
                                .read<PxAuth>()
                                .isActionPermitted(
                                  PermissionEnum.User_Clinics_Prescription,
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
                            c.selectClinic(clinic);
                            await showDialog<void>(
                              context: context,
                              builder: (context) {
                                return ChangeNotifierProvider.value(
                                  value: c,
                                  child: ClinicPrescriptionDialog(),
                                );
                              },
                            ).whenComplete(() {
                              c.selectClinic(null);
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.warehouse_rounded),
                              Text(context.loc.clinicInventory),
                            ],
                          ),
                          onTap: () async {
                            //@permission
                            final _perm = context
                                .read<PxAuth>()
                                .isActionPermitted(
                                  PermissionEnum.User_Clinics_Store,
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
                            c.selectClinic(clinic);
                            await showDialog<void>(
                              context: context,
                              builder: (context) {
                                return ChangeNotifierProvider(
                                  create: (context) => PxClinicInventory(
                                    api: ClinicInventoryApi(
                                      clinic_id: clinic.id,
                                    ),
                                  ),
                                  child: ClinicInventoryDialog(),
                                );
                              },
                            ).whenComplete(() {
                              c.selectClinic(null);
                            });
                          },
                        ),
                        PopupMenuItem<void>(
                          child: Row(
                            children: [
                              const Icon(Icons.warehouse_rounded),
                              Text(context.loc.clinicDoctors),
                            ],
                          ),
                          onTap: () async {
                            final _isSuperAdmin = context
                                .read<PxAuth>()
                                .isLoggedInUserSuperAdmin(context);

                            if (!_isSuperAdmin) {
                              showIsnackbar(
                                context.loc.needSuperAdminPermission,
                              );
                              return;
                            }
                            c.selectClinic(clinic);
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider.value(
                                      value: PxDoctor(
                                        api: DoctorApi(
                                          doc_id: context.read<PxAuth>().doc_id,
                                          org_id:
                                              '${context.read<PxAuth>().organization?.id}',
                                        ),
                                        context: context,
                                      ),
                                    ),
                                    ChangeNotifierProvider.value(
                                      value: PxClinics(
                                        api: ClinicsApi(
                                          doc_id: context.read<PxAuth>().doc_id,
                                        ),
                                        context: context,
                                      ),
                                    ),
                                  ],

                                  child: ClinicDoctorsDialog(),
                                );
                              },
                            ).whenComplete(() {
                              c.selectClinic(null);
                            });
                          },
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.share),
                              Text(context.loc.shareBookingLink),
                            ],
                          ),
                          onTap: () async {
                            String? _url;
                            await shellFunction(
                              context,
                              toExecute: () async {
                                _url = await KuttApi(
                                  clinic.bookingUrlClinic(context),
                                ).shortenLink();
                              },
                              duration: const Duration(milliseconds: 260),
                            );
                            if (_url != null && context.mounted) {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return BookingUrlDialog(
                                    url: _url ?? '',
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
