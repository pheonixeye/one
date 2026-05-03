import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/widgets/book_appointment_tile.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/widgets/patient_tile.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/widgets/visit_tile.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_portal.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class PortalPatientView extends StatelessWidget {
  const PortalPatientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPatientPortal, PxLocale>(
      builder: (context, p, l, _) {
        return Column(
          children: [
            // patient id card
            Builder(
              builder: (context) {
                while (p.api.query.patient_id == null ||
                    p.api.query.patient_id!.isEmpty) {
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
                                  'org_id': p.api.query.org_id,
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
                          'org_id': p.api.query.org_id,
                          'patient_id': '',
                        },
                      );
                    },
                  );
                }
                while (p.patient == null) {
                  return SizedBox();
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
            if (p.api.query.patient_id != null &&
                p.api.query.patient_id!.isNotEmpty &&
                p.patient != null &&
                p.patient is! ApiErrorResult)
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (p.onePatientVisits == null) {
                      return Center(
                        child: ElevatedButton(
                          child: Text(
                            context.loc.showVisits,
                          ),
                          onPressed: () async {
                            await shellFunction(
                              context,
                              toExecute: () async {
                                await p.fetchOnePatientVisits();
                              },
                            );
                          },
                        ),
                      );
                    }
                    while (p.onePatientVisits is ApiErrorResult) {
                      final _err = (p.onePatientVisits as ApiErrorResult);
                      return CentralError(
                        code: _err.errorCode,
                        toExecute: p.fetchOnePatientVisits,
                      );
                    }
                    final _visits =
                        (p.onePatientVisits
                                as ApiDataResult<List<VisitExpanded>>)
                            .data;
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
            Consumer<PxAppConstants>(
              builder: (context, a, _) {
                //TODO: modify to adapt to new booking logic
                final _patient = (p.patient is ApiDataResult)
                    ? (p.patient as ApiDataResult<Patient?>?)?.data
                    : null;
                return BookAppointmentTile(
                  patient: _patient,
                  query: p.api.query,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
