import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:one/assets/assets.dart';
import 'package:one/constants/app_business_constants.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/patient.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_portal.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
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
                            onDetect: (barcodes) async {
                              final _patient_id = barcodes.barcodes.first;
                              await shellFunction(
                                context,
                                toExecute: () async {},
                              );
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
                    return Column(
                      spacing: 8,
                      children: [
                        CentralError(
                          code: _err.errorCode,
                          toExecute: p.retryFetchPatient,
                        ),
                        //TODO: rescan code
                        ElevatedButton.icon(
                          onPressed: () async {},
                          label: Text(context.loc.rescanQrCode),
                          icon: const Icon(Icons.qr_code_2),
                        ),
                      ],
                    );
                  }
                  final _patient = (p.patient as ApiDataResult<Patient>).data;
                  return Card.outlined(
                    elevation: 6,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 8,
                          children: [
                            SmBtn(
                              child: const Icon(Icons.person),
                            ),
                            Text(_patient.name),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 50.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Text(_patient.phone),
                              Text(
                                DateFormat(
                                  'dd-MM-yyyy',
                                  l.lang,
                                ).format(DateTime.parse(_patient.dob)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (p.api.patient_id == null || p.api.patient_id!.isEmpty)
                Expanded(
                  child: Builder(
                    builder: (context) {
                      return ListView(
                        cacheExtent: 3000,
                        children: [
                          // list of patient visits
                        ],
                      );
                    },
                  ),
                )
              else
                Expanded(
                  child: const SizedBox(),
                ),
              // book new appointment
              Card.outlined(
                elevation: 6,
                color: Colors.blue.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(context.loc.bookNewVisit),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(context.loc.bookAppointmentPrompt),
                            ),
                            if (!context.isMobile) ...[
                              const Spacer(),
                              ElevatedButton.icon(
                                onPressed: () async {},
                                label: Text(context.loc.bookAppointment),
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ],
                        ),
                        if (context.isMobile) ...[
                          ElevatedButton.icon(
                            onPressed: () async {
                              //TODO:
                            },
                            label: Text(context.loc.bookAppointment),
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
