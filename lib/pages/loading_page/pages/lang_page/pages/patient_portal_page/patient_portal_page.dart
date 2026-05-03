import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/assets/assets.dart';
import 'package:one/constants/app_business_constants.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/patients_portal/portal_query.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/views/portal_book_view.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/views/portal_patient_view.dart';
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
          body: switch (p.api.query.view) {
            PortalView.patient_view => const PortalPatientView(),
            PortalView.book_view => const PortalBookView(),
            _ => CentralError(
              code: 0,
              toExecute: () async {
                GoRouter.of(context).goNamed(
                  AppRouter.patients_portal,
                  pathParameters: defaultPathParameters(context),
                  queryParameters: {
                    'view': 'new',
                    'org_id': p.api.query.org_id,
                  },
                );
              },
            ),
          },
        );
      },
    );
  }
}
