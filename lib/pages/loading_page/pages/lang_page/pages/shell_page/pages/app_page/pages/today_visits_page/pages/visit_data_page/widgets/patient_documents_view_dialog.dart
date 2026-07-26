import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/profile_items_api/pi_document_types_api.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/pi_document_type.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/document_action_btn.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_documents.dart';
import 'package:one/providers/px_s3_documents.dart';
import 'package:one/providers/px_s3_patient_documents.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientDocumentsViewDialog extends StatefulWidget {
  const PatientDocumentsViewDialog({
    super.key,
    required this.patient,
  });
  final Patient patient;

  @override
  State<PatientDocumentsViewDialog> createState() =>
      _PatientDocumentsViewDialogState();
}

class _PatientDocumentsViewDialogState
    extends State<PatientDocumentsViewDialog> {
  String? _documentTypeId;

  String? _doc_id;

  late final ScrollController _documentsController;

  late final ScrollController _doctorsController;

  final List<ScrollController> _scrollControllers = [];

  late final _auth = context.read<PxAuth>();

  @override
  void initState() {
    super.initState();
    _documentsController = ScrollController();
    _doctorsController = ScrollController();
  }

  @override
  void dispose() {
    _documentsController.dispose();
    _doctorsController.dispose();
    _scrollControllers.map((x) => x.dispose()).toList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Split into 2 views

    if (_auth.isUserNotDoctor) {
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
                      text: '(${widget.patient.name})',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer2<PxDoctor, PxLocale>(
                builder: (context, d, l, _) {
                  while (d.allDoctors == null) {
                    return const SizedBox(
                      height: 4,
                      child: LinearProgressIndicator(),
                    );
                  }
                  final _doctors = d.allDoctors;
                  return Card.outlined(
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
                              Text(context.loc.pickDoctor),
                            ],
                          ),
                        ),
                        subtitle: SizedBox(
                          width: 420,
                          height: 80,
                          child: Scrollbar(
                            controller: _doctorsController,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _doctorsController,
                              scrollDirection: Axis.horizontal,
                              child: Builder(
                                builder: (context) {
                                  return RadioGroup<String>(
                                    groupValue: _doc_id,
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() {
                                          _doc_id = val;
                                          _documentTypeId = null;
                                        });
                                      }
                                    },
                                    child: Row(
                                      spacing: 8,
                                      children: [
                                        ..._doctors!.map((e) {
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
                  );
                },
              ),
              if (_doc_id != null)
                ChangeNotifierProvider.value(
                  value: PxPiDocuments(
                    api: PiDocumentTypesApi(
                      doc_id: _doc_id ?? '',
                    ),
                  ),
                  builder: (context, child) {
                    return Card.outlined(
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
                          subtitle:
                              Consumer3<
                                PxPiDocuments,
                                PxS3PatientDocuments,
                                PxLocale
                              >(
                                builder: (context, pd, d, l, _) {
                                  while (pd.documentTypes == null) {
                                    return const SizedBox(
                                      height: 4,
                                      child: LinearProgressIndicator(),
                                    );
                                  }
                                  while (pd.documentTypes is ApiErrorResult) {
                                    final _err =
                                        (pd.documentTypes
                                            as ApiErrorResult<
                                              List<PiDocumentType>
                                            >);
                                    return CentralError(
                                      code: _err.errorCode,
                                      toExecute: d.retry,
                                    );
                                  }
                                  final _documentTypes =
                                      (pd.documentTypes
                                              as ApiDataResult<
                                                List<PiDocumentType>
                                              >)
                                          .data;
                                  return SizedBox(
                                    width: 420,
                                    height: 80,
                                    child: Scrollbar(
                                      controller: _documentsController,
                                      scrollbarOrientation:
                                          ScrollbarOrientation.bottom,
                                      thumbVisibility: true,
                                      child: SingleChildScrollView(
                                        controller: _documentsController,
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
                                                  d.filterAndGroup(
                                                    _documentTypeId!,
                                                  );
                                                }
                                              },
                                              child: Row(
                                                spacing: 8,
                                                children: [
                                                  ..._documentTypes.map((e) {
                                                    return SizedBox(
                                                      width: 120,
                                                      child:
                                                          RadioListTile<String>(
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
                                  );
                                },
                              ),
                        ),
                      ),
                    );
                  },
                ),
              if (_documentTypeId != null)
                Expanded(
                  child: Consumer2<PxS3PatientDocuments, PxLocale>(
                    builder: (context, d, l, _) {
                      return ListView(
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
                                        final _scrollController =
                                            ScrollController(
                                              debugLabel: docs.key
                                                  .toIso8601String(),
                                            );
                                        _scrollControllers.add(
                                          _scrollController,
                                        );
                                        return Scrollbar(
                                          controller: _scrollController,
                                          thumbVisibility: true,
                                          scrollbarOrientation:
                                              ScrollbarOrientation.bottom,
                                          child: SingleChildScrollView(
                                            controller: _scrollController,
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                spacing: 8,
                                                children: [
                                                  ...docs.value.map((doc) {
                                                    return ChangeNotifierProvider.value(
                                                      key: ValueKey(doc.id),
                                                      value: PxS3Documents(
                                                        context: context,
                                                        objectName:
                                                            doc.document_url,
                                                        state:
                                                            S3DocumentsPxState
                                                                .fetch,
                                                      ),
                                                      child: DocumentActionBtn(
                                                        document: doc,
                                                      ),
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
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return Consumer3<PxPiDocuments, PxS3PatientDocuments, PxLocale>(
      builder: (context, a, d, l, _) {
        while (a.documentTypes == null || d.documents == null) {
          return const CentralLoading();
        }
        final _result = (d.documents as ApiResult<List<PatientDocument>>);
        while (_result is ApiErrorResult<List<PatientDocument>> ||
            a.documentTypes is ApiErrorResult) {
          return CentralError(
            code: (_result as ApiErrorResult).errorCode,
            toExecute: () async {
              a.retry();
              d.retry();
            },
          );
        }
        final _data = (_result as ApiDataResult<List<PatientDocument>>).data;
        final _documentTypes =
            (a.documentTypes as ApiDataResult<List<PiDocumentType>>).data;
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
                        text: '(${widget.patient.name})',
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
                          controller: _documentsController,
                          scrollbarOrientation: ScrollbarOrientation.bottom,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _documentsController,
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
                                                return ChangeNotifierProvider.value(
                                                  key: ValueKey(doc.id),
                                                  value: PxS3Documents(
                                                    context: context,
                                                    objectName:
                                                        doc.document_url,
                                                    state: S3DocumentsPxState
                                                        .fetch,
                                                  ),
                                                  child: DocumentActionBtn(
                                                    document: doc,
                                                  ),
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
