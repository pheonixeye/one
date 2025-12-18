import 'dart:typed_data';

import 'package:one/core/api/patient_document_api.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/forms_page/document_type_picker_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/forms_page/visual_sheet_dialog.dart';
import 'package:one/widgets/floating_ax_menu_bubble.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/pc_form.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/models/visit_data/visit_form_item.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/forms_page/form_picker_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/forms_page/form_view_edit_card.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_forms.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VisitFormsPage extends StatefulWidget {
  const VisitFormsPage({super.key});

  @override
  State<VisitFormsPage> createState() => _VisitFormsPageState();
}

class _VisitFormsPageState extends State<VisitFormsPage>
    with SingleTickerProviderStateMixin {
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxVisitData, PxForms, PxLocale>(
      builder: (context, v, f, l, _) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              while (f.result == null || v.result == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult) {
                return CentralError(
                  code: (f.result as ApiErrorResult).errorCode,
                  toExecute: f.retry,
                );
              }
              while ((v.result as ApiDataResult<VisitData>)
                  .data
                  .forms
                  .isEmpty) {
                return Column(
                  children: [
                    VisitDetailsPageInfoHeader(
                      patient:
                          (v.result as ApiDataResult<VisitData>).data.patient,
                      title: context.loc.visitForms,
                      iconData: Icons.edit_document,
                    ),
                    Expanded(
                      child: CentralNoItems(message: context.loc.noItemsFound),
                    ),
                  ],
                );
              }
              final _data = (v.result as ApiDataResult<VisitData>).data;
              final _items = _data.forms;
              return Column(
                children: [
                  VisitDetailsPageInfoHeader(
                    patient:
                        (v.result as ApiDataResult<VisitData>).data.patient,
                    title: context.loc.visitForms,
                    iconData: Icons.edit_document,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final _item = _items[index];
                        return VisitFormViewEditCard(
                          form: _item,
                          index: index,
                          form_data: (v.result as ApiDataResult<VisitData>)
                              .data
                              .forms_data
                              .firstWhere((x) => x.form_id == _item.id),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
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
                title: context.loc.addNewForm,
                iconColor: Colors.white,
                bubbleColor: Theme.of(
                  context,
                ).floatingActionButtonTheme.backgroundColor!,
                icon: Icons.add,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () async {
                  _animationController.reverse();
                  final _form = await showDialog<PcForm?>(
                    context: context,
                    builder: (context) {
                      return const FormPickerDialog();
                    },
                  );
                  if (_form == null) {
                    return;
                  }
                  final _visit_form_data = VisitFormItem(
                    id: '',
                    visit_id:
                        (v.result as ApiDataResult<VisitData>).data.visit_id,
                    patient_id:
                        (v.result as ApiDataResult<VisitData>).data.patient.id,
                    form_id: _form.id,
                    form_data: _form.form_fields
                        .map(
                          (x) => SingleFieldData(
                            id: x.id,
                            field_name: x.field_name,
                            field_value: '',
                          ),
                        )
                        .toList(),
                  );
                  if (context.mounted) {
                    await shellFunction(
                      context,
                      toExecute: () async {
                        await v.attachForm(_visit_form_data);
                      },
                    );
                  }
                },
              ),
              Bubble(
                title: context.loc.addDrawingSheet,
                iconColor: Colors.white,
                bubbleColor: Theme.of(
                  context,
                ).floatingActionButtonTheme.backgroundColor!,
                icon: FontAwesomeIcons.personChalkboard,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () async {
                  _animationController.reverse();
                  //todo: open visual sheet dialog
                  final _data = (v.result as ApiDataResult<VisitData>).data;
                  Uint8List? _imageData;
                  String? _documentTypeId;
                  _imageData = await showDialog<Uint8List?>(
                    context: context,
                    builder: (context) {
                      return VisualSheetDialog(visitData: _data);
                    },
                  );
                  if (_imageData == null) {
                    return;
                  }
                  if (context.mounted) {
                    //todo: select document type
                    _documentTypeId = await showDialog<String?>(
                      context: context,
                      builder: (context) {
                        return DocumentTypePickerDialog();
                      },
                    );
                  }
                  if (_documentTypeId == null) {
                    return;
                  }
                  if (context.mounted) {
                    final _document = PatientDocument(
                      id: '',
                      patient_id: _data.patient.id,
                      related_visit_id: _data.visit_id,
                      related_visit_data_id: _data.id,
                      document_type_id: _documentTypeId,
                      document: '',
                    );
                    await shellFunction(
                      context,
                      toExecute: () async {
                        //todo: save document to patient
                        await PatientDocumentApi(
                          patient_id: _data.patient.id,
                        ).addPatientDocument(
                          _document,
                          _imageData!,
                          '${DateFormat('dd-MM-yyyy', 'en').format(DateTime.now())}.jpg',
                        );
                      },
                    );
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
