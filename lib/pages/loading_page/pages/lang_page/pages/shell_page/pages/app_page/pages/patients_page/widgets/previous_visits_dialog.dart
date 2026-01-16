import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/previous_visit_view_card.dart';
import 'package:one/providers/px_patient_previous_visits.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class PreviousVisitsDialog extends StatelessWidget {
  const PreviousVisitsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPatientPreviousVisits, PxLocale>(
      builder: (context, p, l, _) {
        while (p.data == null) {
          return CentralLoading();
        }
        while (p.data is ApiErrorResult) {
          return CentralError(
            code: (p.data as ApiErrorResult).errorCode,
            toExecute: p.retry,
          );
        }
        while (p.data != null &&
            (p.data! as ApiDataResult<List<VisitExpanded>>).data.isEmpty) {
          return CentralNoItems(
            message: context.loc.noVisitsFoundForThisPatient,
          );
        }
        final _data = (p.data as ApiDataResult<List<VisitExpanded>>).data;
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.previousPatientVisits,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '(${_data.first.patient.name})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      final item = _data[index];
                      return PreviousVisitViewCard(index: index, item: item);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(
                      tooltip: context.loc.previous,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await p.previousPage();
                          },
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text('-${p.page}-'.toArabicNumber(context)),
                    ),
                    IconButton.outlined(
                      tooltip: context.loc.next,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await p.nextPage();
                          },
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
