import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/doctor_doument_type.dart';
import 'package:one/models/patient_document/expanded_patient_document.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/document_action_btn.dart';
import 'package:one/providers/px_doctor_profile_items.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patient_documents.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientDocumentsViewDialog extends StatefulWidget {
  const PatientDocumentsViewDialog({super.key});

  @override
  State<PatientDocumentsViewDialog> createState() =>
      _PatientDocumentsViewDialogState();
}

class _PatientDocumentsViewDialogState
    extends State<PatientDocumentsViewDialog> {
  String? _documentTypeId;
  late final ScrollController _controller;

  final List<ScrollController> _scrollControllers = [];

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollControllers.map((x) => x.dispose()).toList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      PxDoctorProfileItems<DoctorDocumentTypeItem>,
      PxPatientDocuments,
      PxLocale
    >(
      builder: (context, a, d, l, _) {
        while (a.data == null || d.documents == null) {
          return const CentralLoading();
        }
        final _result =
            (d.documents as ApiResult<List<ExpandedPatientDocument>>);
        while (_result is ApiErrorResult<List<ExpandedPatientDocument>> ||
            a.data is ApiErrorResult) {
          return CentralError(
            code: (_result as ApiErrorResult).errorCode,
            toExecute: () async {
              a.retry();
              d.retry();
            },
          );
        }
        final _data =
            (_result as ApiDataResult<List<ExpandedPatientDocument>>).data;
        final _documentTypes =
            (a.data as ApiDataResult<List<DoctorDocumentTypeItem>>).data;
        while (_data.isEmpty) {
          return CentralNoItems(message: context.loc.noItemsFound);
        }
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.patientDocuments,
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
              spacing: 8,
              children: [
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 8,
                          children: [
                            const SmBtn(),
                            Text(context.loc.pickDocumentType),
                          ],
                        ),
                      ),
                      subtitle: SizedBox(
                        width: 420,
                        height: 80,
                        child: Scrollbar(
                          controller: _controller,
                          scrollbarOrientation: ScrollbarOrientation.bottom,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            child: Builder(
                              builder: (context) {
                                return RadioGroup<String>(
                                  groupValue: _documentTypeId,
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _documentTypeId = val;
                                      });
                                      d.filterAndGroup(_documentTypeId!);
                                    }
                                  },
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      ..._documentTypes.map((e) {
                                        return SizedBox(
                                          width: 120,
                                          child: RadioListTile<String>(
                                            title: Text(
                                              l.isEnglish
                                                  ? e.name_en
                                                  : e.name_ar,
                                            ),
                                            value: e.id,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      if (d.groupedDocuments != null)
                        ...d.groupedDocuments!.entries.map((docs) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                DateFormat(
                                  'dd - MM - yyyy',
                                  l.lang,
                                ).format(docs.key),
                              ),
                              subtitle: SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: 140,
                                child: Builder(
                                  builder: (context) {
                                    final _scrollController = ScrollController(
                                      debugLabel: docs.key.toIso8601String(),
                                    );
                                    _scrollControllers.add(_scrollController);
                                    return Scrollbar(
                                      controller: _scrollController,
                                      thumbVisibility: true,
                                      scrollbarOrientation:
                                          ScrollbarOrientation.bottom,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            spacing: 8,
                                            children: [
                                              ...docs.value.map((doc) {
                                                return DocumentActionBtn(
                                                  document: doc,
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
