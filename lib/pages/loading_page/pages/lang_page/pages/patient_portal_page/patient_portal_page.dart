import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:one/assets/assets.dart';
import 'package:one/constants/app_business_constants.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/widgets/book_appointment_tile.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/widgets/patient_tile.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/widgets/visit_tile.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_portal.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class PatientPortalPage extends StatelessWidget {
  const PatientPortalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPatientPortal, PxLocale>(
      builder: (context, p, l, _) {
        while (p.organization == null) {
          return const CentralLoading();
        }

        while (p.organization is ApiErrorResult) {
          final _err = (p.organization as ApiErrorResult);
          return CentralError(
            code: _err.errorCode,
            toExecute: p.retryFetchOrganization,
          );
        }
        final _org = (p.organization as ApiDataResult<Organization>).data;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              spacing: 8,
              children: [
                SizedBox(width: context.isMobile ? 10 : 50),
                Image.asset(
                  AppAssets.icon,
                  width: 40,
                  height: 40,
                ),
                const Text.rich(
                  TextSpan(
                    text: String.fromEnvironment('APPLICATION_NAME'),
                    children: [
                      TextSpan(text: '\n', style: TextStyle(fontSize: 8)),
                      TextSpan(
                        text: 'v${AppBusinessConstants.ALLEVIA_VERSION}',
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      l.isEnglish ? _org.name_en : _org.name_ar,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Text(' - '),
                    Text(context.loc.patientPortal),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              // patient id card
              Builder(
                builder: (context) {
                  while (p.api.patient_id == null ||
                      p.api.patient_id!.isEmpty) {
                    return Column(
                      spacing: 8,
                      children: [
                        Text(context.loc.scanQrCode),
                        SizedBox(
                          height: 350,
                          width: 350,
                          child: MobileScanner(
                            onDetect: (barcodes) {
                              if (barcodes.barcodes.isNotEmpty) {
                                final _patient_id = barcodes.barcodes.first;
                                GoRouter.of(
                                  context,
                                ).goNamed(
                                  AppRouter.patients_portal,
                                  pathParameters: defaultPathParameters(
                                    context,
                                  ),
                                  queryParameters: {
                                    'org_id': p.api.org_id,
                                    'patient_id': _patient_id,
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  while (p.patient == null) {
                    return const CentralLoading();
                  }
                  while (p.patient is ApiErrorResult) {
                    final _err = (p.patient as ApiErrorResult);
                    return CentralError(
                      isForQrRescan: true,
                      code: _err.errorCode,
                      toExecute: () async {
                        GoRouter.of(
                          context,
                        ).goNamed(
                          AppRouter.patients_portal,
                          pathParameters: defaultPathParameters(
                            context,
                          ),
                          queryParameters: {
                            'org_id': p.api.org_id,
                            'patient_id': '',
                          },
                        );
                      },
                    );
                  }
                  final _patient = (p.patient as ApiDataResult<Patient>).data;
                  return PatientTile(
                    patient: _patient,
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.loc.visits),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              if (p.api.patient_id != null &&
                  p.api.patient_id!.isNotEmpty &&
                  p.patient != null &&
                  p.patient is! ApiErrorResult)
                Expanded(
                  child: Builder(
                    builder: (context) {
                      while (p.visits == null) {
                        return Center(
                          child: ElevatedButton(
                            child: Text(
                              context.loc.showVisits,
                            ),
                            onPressed: () async {
                              await shellFunction(
                                context,
                                toExecute: () async {
                                  await p.fetchVisits();
                                },
                              );
                            },
                          ),
                        );
                      }
                      while (p.visits is ApiErrorResult) {
                        final _err = (p.visits as ApiErrorResult);
                        return CentralError(
                          code: _err.errorCode,
                          toExecute: p.fetchVisits,
                        );
                      }
                      final _visits =
                          (p.visits as ApiDataResult<List<VisitExpanded>>).data;
                      return ListView.builder(
                        cacheExtent: 3000,
                        itemCount: _visits.length,
                        itemBuilder: (context, index) {
                          final _item = _visits[index];
                          return VisitTile(
                            item: _item,
                            index: index,
                          );
                        },
                      );
                    },
                  ),
                )
              else
                Expanded(
                  child: const SizedBox(),
                ),
              // book new appointment
              const BookAppointmentTile(),
            ],
          ),
        );
      },
    );
  }
}
