import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:provider/provider.dart';

enum _viewState {
  attendance,
  progress;

  _viewState toggle() {
    return this == attendance ? progress : attendance;
  }
}

class TodayVisitsStateCounter extends StatefulWidget {
  const TodayVisitsStateCounter({super.key});

  @override
  State<TodayVisitsStateCounter> createState() =>
      _TodayVisitsStateCounterState();
}

class _TodayVisitsStateCounterState extends State<TodayVisitsStateCounter> {
  _viewState _state = _viewState.progress;
  final _progressStates = <String>[
    'Has Not Attended Yet',
    'Canceled',
    'In Waiting',
    'In Consultation',
    'Done Consultation',
  ];

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 80,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: () {
            setState(() {
              _state = _state.toggle();
            });
          },
          child: Card.outlined(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
            color: Colors.amber.shade50,
            child: Consumer3<PxAuth, PxVisits, PxLocale>(
              builder: (context, a, v, l, _) {
                while (a.user == null || v.visits == null) {
                  return SizedBox(
                    height: 8,
                    child: const LinearProgressIndicator(),
                  );
                }
                while (v.visits is ApiErrorResult) {
                  return Tooltip(
                    message: context.loc.errorFetchingVisits,
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                }
                var _data =
                    (v.visits as ApiDataResult<List<VisitExpanded>>).data;
                if (!a.isUserNotDoctor) {
                  _data = _data.where((e) => e.doc_id == a.doc_id).toList();
                }
                while (_data.isEmpty) {
                  return Row(
                    spacing: 2,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info,
                        color: Colors.blue,
                      ),
                      Text(
                        context.loc.noVisitsFoundForToday,
                      ),
                    ],
                  );
                }
                return switch (_state) {
                  _viewState.attendance => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...['Attended', 'Not Attended'].map((x) {
                          return Expanded(
                            child: Tooltip(
                              message: x,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: switch (x) {
                                  'Attended' => Colors.blue.shade400,
                                  'Not Attended' => Colors.red.shade400,
                                  _ => Colors.white,
                                },
                                child: Builder(
                                  builder: (context) {
                                    final _count = _data
                                        .where(
                                          (e) => e.visit_status == x,
                                        )
                                        .length;
                                    return Text('$_count');
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  _viewState.progress => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ..._progressStates.map((x) {
                          return Expanded(
                            child: Tooltip(
                              message: x,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: switch (x) {
                                  'Has Not Attended Yet' => Colors.white,
                                  'Canceled' => Colors.red.shade400,
                                  'In Waiting' => Colors.yellow.shade400,
                                  'In Consultation' => Colors.green.shade400,
                                  'Done Consultation' => Colors.blue.shade400,
                                  _ => Colors.white,
                                },
                                child: Builder(
                                  builder: (context) {
                                    final _count = _data
                                        .where(
                                          (e) => e.patient_progress_status == x,
                                        )
                                        .length;
                                    return Text('$_count');
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}
