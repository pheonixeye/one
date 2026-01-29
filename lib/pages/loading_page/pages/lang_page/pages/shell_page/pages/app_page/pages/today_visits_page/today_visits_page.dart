import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/core/api/patients_api.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog/add_new_visit_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/scan_patient_qr_dialog.dart';
import 'package:one/providers/px_add_new_visit_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_one_visit_bookkeeping.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/not_permitted_template_page.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/clinics_tab_bar.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/floating_ax_menu_bubble.dart';
import 'package:provider/provider.dart';

class TodayVisitsPage extends StatefulWidget {
  const TodayVisitsPage({super.key});

  @override
  State<TodayVisitsPage> createState() => _TodayVisitsPageState();
}

class _TodayVisitsPageState extends State<TodayVisitsPage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<PxAppConstants, PxVisits, PxClinics, PxLocale>(
      builder: (context, a, v, c, l, _) {
        while (a.constants == null || c.result == null) {
          return const CentralLoading();
        }
        //@permission
        final _perm = context.read<PxAuth>().isActionPermitted(
          PermissionEnum.User_TodayVisits_Read,
          context,
        );
        while (!_perm.isAllowed) {
          return NotPermittedTemplatePage(title: context.loc.todayVisits);
        }
        while (c.result is ApiErrorResult) {
          return CentralError(
            code: (c.result as ApiErrorResult).errorCode,
            toExecute: c.retry,
          );
        }

        while ((c.result as ApiDataResult<List<Clinic>>).data.isEmpty) {
          return CentralNoItems(message: context.loc.noClinicsFound);
        }

        final _clinics = (c.result as ApiDataResult<List<Clinic>>).data;

        _tabController = TabController(length: _clinics.length, vsync: this);
        return Scaffold(
          body: Column(
            children: [
              Stack(
                children: [
                  ClinicsTabBar(clinics: _clinics, controller: _tabController!),
                  if (v.isUpdating)
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
                    while (v.visits == null) {
                      return const CentralLoading();
                    }

                    while (v.visits is ApiErrorResult) {
                      return CentralError(
                        code:
                            (v.visits as ApiErrorResult<List<Visit>>).errorCode,
                        toExecute: v.retry,
                      );
                    }

                    while (v.visits != null &&
                        (v.visits is ApiDataResult) &&
                        (v.visits as ApiDataResult<List<Visit>>).data.isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noVisitsFoundForToday,
                      );
                    }
                    final _items =
                        (v.visits as ApiDataResult<List<VisitExpanded>>).data;
                    return TabBarView(
                      controller: _tabController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        ...(c.result as ApiDataResult<List<Clinic>>).data.map((
                          x,
                        ) {
                          final _clinicItems = _items
                              .where((e) => e.clinic_id == x.id)
                              .toList();

                          while (_clinicItems.isEmpty) {
                            return CentralNoItems(
                              message: context.loc.noVisitsFoundForToday,
                            );
                          }

                          return ListView.builder(
                            itemCount: _clinicItems.length,
                            cacheExtent: 3000,
                            itemBuilder: (context, index) {
                              final _item = _clinicItems[index];
                              return ChangeNotifierProvider.value(
                                value: PxOneVisitBookkeeping(
                                  api: BookkeepingApi(visit_id: _item.id),
                                ),
                                child: VisitViewCard(
                                  visit: _item,
                                  index: index,
                                ),
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
          ),
          floatingActionButton: FloatingActionMenuBubble(
            animation: _animation,
            // On pressed change animation state
            onPress: () => _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward(),
            // Floating Action button Icon color
            iconColor: Colors.white,
            // Flaoting Action button Icon
            // iconData: Icons.settings,
            animatedIconData: AnimatedIcons.menu_arrow,
            backGroundColor: Theme.of(
              context,
            ).floatingActionButtonTheme.backgroundColor!,
            items: [
              Bubble(
                title: context.loc.refresh,
                iconColor: Colors.white,
                bubbleColor: Theme.of(
                  context,
                ).floatingActionButtonTheme.backgroundColor!,
                icon: Icons.refresh,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () async {
                  _animationController.reverse();
                  //@permission
                  final _perm = context.read<PxAuth>().isActionPermitted(
                    PermissionEnum.User_TodayVisits_Read,
                    context,
                  );
                  if (!_perm.isAllowed) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return NotPermittedDialog(permission: _perm.permission);
                      },
                    );
                    return;
                  }
                  await shellFunction(
                    context,
                    toExecute: () async {
                      await v.retry();
                    },
                  );
                },
              ),
              Bubble(
                title: context.loc.addNewVisit,
                iconColor: Colors.white,
                bubbleColor: Theme.of(
                  context,
                ).floatingActionButtonTheme.backgroundColor!,
                icon: Icons.add,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () async {
                  _animationController.reverse();
                  //@permission
                  final _perm = context.read<PxAuth>().isActionPermitted(
                    PermissionEnum.User_Patient_AddNewVisit,
                    context,
                  );
                  if (!_perm.isAllowed) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return NotPermittedDialog(permission: _perm.permission);
                      },
                    );
                    return;
                  }
                  GoRouter.of(context).goNamed(
                    AppRouter.patients,
                    pathParameters: defaultPathParameters(context),
                  );
                },
              ),
              Bubble(
                title: context.loc.scanQrCode,
                iconColor: Colors.white,
                bubbleColor: Theme.of(
                  context,
                ).floatingActionButtonTheme.backgroundColor!,
                icon: Icons.qr_code,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () async {
                  _animationController.reverse();
                  //@permission
                  final _perm = context.read<PxAuth>().isActionPermitted(
                    PermissionEnum.User_Patient_AddNewVisit,
                    context,
                  );
                  if (!_perm.isAllowed) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return NotPermittedDialog(permission: _perm.permission);
                      },
                    );
                    return;
                  }
                  Patient? _patientFromDb;
                  //todo: scan code
                  final _patientId = await showDialog<String?>(
                    context: context,
                    builder: (context) {
                      return ScanPatientQrDialog();
                    },
                  );
                  if (_patientId == null) {
                    return;
                  }
                  //todo: get patient data
                  if (context.mounted) {
                    await shellFunction(
                      context,
                      toExecute: () async {
                        _patientFromDb = await PatientsApi.getPatientById(
                          _patientId,
                        );
                      },
                      duration: const Duration(milliseconds: 260),
                    );
                  }
                  if (context.mounted) {
                    if (_patientFromDb == null) {
                      showIsnackbar(context.loc.noPatientsFound);
                      return;
                    }
                    //todo: open new visit dialog
                    final _visitDto = await showDialog<Visit?>(
                      context: context,
                      builder: (context) {
                        return ChangeNotifierProvider(
                          create: (context) => PxAddNewVisitDialog(
                            context: context,
                          ),
                          child: AddNewVisitDialog(
                            patient: _patientFromDb!,
                          ),
                        );
                      },
                    );
                    //todo: create new visit
                    if (_visitDto == null) {
                      return;
                    }
                    if (context.mounted) {
                      await shellFunction(
                        context,
                        toExecute: () async {
                          await v.addNewVisit(_visitDto);
                        },
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


// SmBtn(
//   heroTag: 'add-new-visit-nav',
//   tooltip: context.loc.addNewVisit,
//   onPressed: () {
//     GoRouter.of(context).goNamed(
//       AppRouter.patients,
//       pathParameters: defaultPathParameters(context),
//     );
//   },
//   child: const Icon(Icons.add),
// ),