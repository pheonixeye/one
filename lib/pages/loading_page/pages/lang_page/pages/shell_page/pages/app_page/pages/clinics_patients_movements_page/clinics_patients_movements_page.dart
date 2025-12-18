import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/today_patient_progress_api.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_patients_movements_page/widgets/visit_progression_card.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/clinics_tab_bar.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_today_patient_progress.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class ClinicsPatientsMovementsPage extends StatefulWidget {
  const ClinicsPatientsMovementsPage({super.key});

  @override
  State<ClinicsPatientsMovementsPage> createState() =>
      _ClinicsPatientsMovementsPageState();
}

class _ClinicsPatientsMovementsPageState
    extends State<ClinicsPatientsMovementsPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  Timer? _timer;
  final _changeDuration = const Duration(seconds: 10);
  final _animationDuration = const Duration(microseconds: 500);
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_changeDuration, (tim) {
      if (_tabController != null) {
        try {
          _tabController!.animateTo(
            _tabController!.index + 1,
            duration: _animationDuration,
          );
        } catch (e) {
          _tabController!.animateTo(0, duration: _animationDuration);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxClinics, PxLocale>(
      builder: (context, c, l, _) {
        while (c.result == null) {
          return const CentralLoading();
        }

        while ((c.result as ApiDataResult<List<Clinic>>).data.isEmpty) {
          return CentralNoItems(message: context.loc.noClinicsFound);
        }

        final _clinics = (c.result as ApiDataResult<List<Clinic>>).data;

        _tabController = TabController(length: _clinics.length, vsync: this);

        final _clinic = _tabController != null
            ? _clinics[_tabController!.index]
            : null;

        while (_clinic == null) {
          return CentralLoading();
        }
        //TODO: add shifts in the top beside the clinics
        //todo: change ui or make tabs animate on timer
        return Scaffold(
          body: ChangeNotifierProvider(
            create: (context) => PxTodayPatientProgress(
              api: TodayPatientProgressApi(
                doc_id: PxAuth.doc_id_static_getter,
                clinic_id: _clinic.id,
              ),
            ),
            child: Consumer<PxTodayPatientProgress>(
              builder: (context, t, _) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        ClinicsTabBar(
                          clinics: _clinics,
                          controller: _tabController!,
                        ),
                        if (t.isUpdating)
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                      ],
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // while (t.visits == null) {
                          //   return const CentralLoading();
                          // }

                          // while (v.visits is ApiErrorResult) {
                          //   return CentralError(
                          //     code: (v.visits as ApiErrorResult<List<Visit>>)
                          //         .errorCode,
                          //     toExecute: v.retry,
                          //   );
                          // }

                          while (t.visits.isEmpty) {
                            return CentralNoItems(
                              message: context.loc.noVisitsFoundForToday,
                            );
                          }
                          final _items = t.visits;
                          return TabBarView(
                            controller: _tabController,
                            physics: BouncingScrollPhysics(),
                            children: [
                              ...(c.result as ApiDataResult<List<Clinic>>).data
                                  .map((x) {
                                    final _clinicItems = _items
                                        .where((e) => e.clinic.id == x.id)
                                        .toList();

                                    while (_clinicItems.isEmpty) {
                                      return CentralNoItems(
                                        message:
                                            context.loc.noVisitsFoundForToday,
                                      );
                                    }

                                    return ListView.builder(
                                      itemCount: _clinicItems.length,
                                      itemBuilder: (context, index) {
                                        final _item = _clinicItems[index];
                                        return VisitProgressionCard(
                                          item: _item,
                                        );
                                      },
                                    );
                                  }),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
