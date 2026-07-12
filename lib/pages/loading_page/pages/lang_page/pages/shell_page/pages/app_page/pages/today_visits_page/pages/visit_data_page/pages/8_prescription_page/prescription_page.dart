import 'dart:typed_data';

import 'package:one/constants/app_business_constants.dart';
import 'package:one/extensions/datetime_ext.dart';
import 'package:one/models/clinic/prescription_details.dart';
import 'package:one/models/doctor_items/pi_document_type.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/2_forms_page/document_type_picker_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/8_prescription_page/widget_by_key.dart';
import 'package:one/providers/px_s3_patient_documents.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/model_url_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/8_prescription_page/prescription_printer_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/providers/px_visit_prescription_state.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class VisitPrescriptionPage extends StatelessWidget {
  const VisitPrescriptionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<PxVisitData, PxVisitPrescriptionState, PxLocale>(
        builder: (context, vd, s, l, _) {
          while (vd.result == null) {
            return const CentralLoading();
          }
          final visit_data = (vd.result as ApiDataResult<VisitData>).data;

          final visit = visit_data.visit;

          final clinic = visit_data.clinic;

          if (clinic == null) {
            return CentralError(
              code: 1,
              toExecute: vd.retry,
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Screenshot(
                      controller: s.screenshotControllerWithImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: clinic.prescriptionFileUrl().isEmpty
                              ? null
                              : DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    clinic.prescriptionFileUrl(),
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                        child: Screenshot(
                          controller: s.screenshotControllerWithoutImage,
                          child: Stack(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            alignment: Alignment.center,
                            fit: StackFit.expand,
                            children: [
                              //todo: put items
                              ...PrescriptionDetails.initial().details.entries.map((
                                x,
                              ) {
                                final _left =
                                    s.visitPrescriptionItemsOffset[x.key]?.dx ??
                                    x.value.x_coord;
                                final _top =
                                    s.visitPrescriptionItemsOffset[x.key]?.dy ??
                                    x.value.y_coord;
                                return Visibility(
                                  visible: s.view == PrescriptionView.regular
                                      ? s.visitPrescriptionVisibility[x.key]!
                                      : true,
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Positioned(
                                      left: _left,
                                      top: _top,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onPanUpdate: (details) {
                                          double _updatedX =
                                              s
                                                  .visitPrescriptionItemsOffset[x
                                                      .key]!
                                                  .dx +
                                              details.delta.dx;
                                          double _updatedY =
                                              s
                                                  .visitPrescriptionItemsOffset[x
                                                      .key]!
                                                  .dy +
                                              details.delta.dy;
                                          s.updateItemOffset(
                                            x.key,
                                            Offset(
                                              _updatedX,
                                              _updatedY,
                                            ),
                                          );
                                        },
                                        onDoubleTap: () {
                                          s.increaseItemFontSize(x.key);
                                        },

                                        onLongPress: () {
                                          s.decreaseItemFontSize(x.key);
                                        },

                                        child: switch (x.key) {
                                          'patient_name' => WidgetByKey(
                                            mapKey: x.key,
                                            visit_data: visit_data,
                                          ),
                                          'visit_date' => WidgetByKey(
                                            mapKey: x.key,
                                            visit_data: visit_data,
                                          ),
                                          'visit_type' => WidgetByKey(
                                            mapKey: x.key,
                                            visit_data: visit_data,
                                          ),
                                          _ => SizedBox(),
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              if (s.view == PrescriptionView.regular)
                                ...PrescriptionDetails.initial().details.entries.map((
                                  x,
                                ) {
                                  final _left =
                                      s
                                          .visitPrescriptionItemsOffset[x.key]
                                          ?.dx ??
                                      x.value.x_coord;
                                  final _top =
                                      s
                                          .visitPrescriptionItemsOffset[x.key]
                                          ?.dy ??
                                      x.value.y_coord;
                                  return Visibility(
                                    visible:
                                        s.visitPrescriptionVisibility[x.key] ??
                                        true,
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Positioned(
                                        left: _left,
                                        top: _top,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onPanUpdate: (details) {
                                            double _updatedX =
                                                s
                                                    .visitPrescriptionItemsOffset[x
                                                        .key]!
                                                    .dx +
                                                details.delta.dx;
                                            double _updatedY =
                                                s
                                                    .visitPrescriptionItemsOffset[x
                                                        .key]!
                                                    .dy +
                                                details.delta.dy;
                                            s.updateItemOffset(
                                              x.key,
                                              Offset(_updatedX, _updatedY),
                                            );
                                          },
                                          onDoubleTap: () {
                                            s.increaseItemFontSize(x.key);
                                          },

                                          onLongPress: () {
                                            s.decreaseItemFontSize(x.key);
                                          },

                                          child: switch (x.key) {
                                            'visit_labs' => WidgetByKey(
                                              mapKey: x.key,
                                              visit_data: visit_data,
                                            ),
                                            'visit_rads' => WidgetByKey(
                                              mapKey: x.key,
                                              visit_data: visit_data,
                                            ),
                                            'visit_procedures' => WidgetByKey(
                                              mapKey: x.key,
                                              visit_data: visit_data,
                                            ),
                                            'doctor_name' => WidgetByKey(
                                              mapKey: x.key,
                                              visit_data: visit_data,
                                            ),
                                            'visit_drugs' => WidgetByKey(
                                              mapKey: x.key,
                                              visit_data: visit_data,
                                            ),
                                            _ => Text(''),
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              if (s.view == PrescriptionView.forms &&
                                  s.formItems != null)
                                GestureDetector(
                                  onScaleUpdate: (details) {
                                    s.updateFormItemsScale(
                                      details.verticalScale,
                                      details.horizontalScale,
                                    );
                                    s.updateFormItemsOffset(
                                      details.localFocalPoint,
                                    );
                                  },
                                  child: Transform.scale(
                                    scaleX: s.formItemsHorizontalScale,
                                    scaleY: s.formItemsVerticalScale,
                                    origin: s.formItemsOffset,
                                    child: SizedBox(
                                      width: s.formItemsHorizontalScale * 10,
                                      height: s.formItemsVerticalScale * 10,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            s.formItemsCrossAxisAlignment,
                                        children: [
                                          ...s.formItems!.map((f) {
                                            //todo: Adjust large paragraphs to fit the prescription image
                                            return Text.rich(
                                              TextSpan(
                                                text: '${f.field_name} : \n',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: f.field_value,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: s.formItemsTextAlign,
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 75,
                    width: MediaQuery.sizeOf(context).width,
                    child: Card.outlined(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: SmBtn(
                                tooltip: context.loc.toggleFormsView,
                                onPressed: () {
                                  //todo: Toggle View
                                  s.toggleView();
                                },
                                child: const Icon(Icons.unfold_more_sharp),
                              ),
                            ),
                            if (s.view == PrescriptionView.forms) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: SmBtn(
                                  tooltip: context.loc.formTitleAlignment,
                                  onPressed: () {
                                    s.toggleAxisAlignment();
                                  },
                                  child: const Icon(
                                    Icons.align_horizontal_center_rounded,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: SmBtn(
                                  tooltip: context.loc.formTextAlignment,
                                  onPressed: () {
                                    s.toggleTextAlignment();
                                  },
                                  child: const Icon(
                                    Icons.text_rotation_none_rounded,
                                  ),
                                ),
                              ),
                            ],
                            Builder(
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: SmBtn(
                                    tooltip: context.loc.save,
                                    onPressed: () async {
                                      //todo: Print
                                      Uint8List? _bytesWithImage;
                                      PiDocumentType? _documentType;
                                      await shellFunction(
                                        context,
                                        toExecute: () async {
                                          _bytesWithImage = await s
                                              .screenshotControllerWithImage
                                              .capture();
                                          //todo: Add to patient documents collection
                                          if (_bytesWithImage == null) {
                                            if (context.mounted) {
                                              showIsnackbar(
                                                context.loc.error,
                                              );
                                              return;
                                            }
                                          }
                                          if (context.mounted) {
                                            //todo: select document type
                                            _documentType =
                                                await showDialog<
                                                  PiDocumentType?
                                                >(
                                                  context: context,
                                                  builder: (context) {
                                                    return DocumentTypePickerDialog();
                                                  },
                                                );
                                          }
                                          if (_documentType == null) {
                                            return;
                                          }

                                          final _patientDocument =
                                              PatientDocument(
                                                id: '',
                                                patient_id: visit!.patient_id,
                                                related_visit_id: visit.id,
                                                related_visit_data_id:
                                                    visit_data.id,
                                                document_type_id:
                                                    _documentType!.id,
                                                document_url: '',
                                                created: DateTime.now().unTimed,
                                              );
                                          if (context.mounted) {
                                            await context
                                                .read<PxS3PatientDocuments>()
                                                .addPatientDocument(
                                                  document: _patientDocument,
                                                  payload: _bytesWithImage,
                                                  objectName:
                                                      '${visit.patient_id}/${_documentType?.name_en}/${intl.DateFormat(AppBusinessConstants.DOCUMENT_NAME_FORMAT, 'en').format(DateTime.now())}.jpg',
                                                );
                                          }
                                        },
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.save),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: SmBtn(
                                tooltip: context.loc.printPrescription,
                                onPressed: () async {
                                  //todo: Print
                                  Uint8List? _bytesWithImage;
                                  Uint8List? _bytesWithoutImage;
                                  await shellFunction(
                                    context,
                                    toExecute: () async {
                                      _bytesWithImage = await s
                                          .screenshotControllerWithImage
                                          .capture();
                                      _bytesWithoutImage = await s
                                          .screenshotControllerWithoutImage
                                          .capture();
                                    },
                                    duration: const Duration(
                                      milliseconds: 500,
                                    ),
                                  );
                                  if (_bytesWithoutImage != null &&
                                      _bytesWithImage != null &&
                                      context.mounted) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PrescriptionPrinterDialog(
                                          dataBytes: _bytesWithoutImage!,
                                          imageBytes: _bytesWithImage!,
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Icon(Icons.print),
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: switch (s.view) {
                                      PrescriptionView.regular => [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 5,
                                          ),
                                          child: MenuAnchor(
                                            builder:
                                                (
                                                  context,
                                                  controller,
                                                  child,
                                                ) {
                                                  return SmBtn(
                                                    onPressed: () {
                                                      if (controller.isOpen) {
                                                        controller.close();
                                                      } else {
                                                        controller.open();
                                                      }
                                                    },
                                                    tooltip: context
                                                        .loc
                                                        .prescriptionItemsVisibility,
                                                    child: const Icon(
                                                      Icons.remove_red_eye,
                                                    ),
                                                  );
                                                },
                                            menuChildren: [
                                              ...PrescriptionDetails.initial()
                                                  .details
                                                  .entries
                                                  .map((e) {
                                                    final _title = l.isEnglish
                                                        ? e.value.name_en
                                                        : e.value.name_ar;

                                                    return MenuItemButton(
                                                      // enabled: false,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          FilterChip(
                                                            selected:
                                                                s.visitPrescriptionVisibility[e
                                                                    .key]!,
                                                            label: Text(
                                                              _title,
                                                            ),
                                                            onSelected: (val) {
                                                              s.toggleVisibility(
                                                                e.key,
                                                              );
                                                            },
                                                          ),
                                                          const Spacer(),
                                                          IconButton(
                                                            onPressed: () {
                                                              s.resetItemOffset(
                                                                e.key,
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons.refresh,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ],

                                      PrescriptionView.forms => [
                                        ...visit_data.forms.map((f) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 8.0,
                                            ),
                                            child: MenuAnchor(
                                              builder:
                                                  (
                                                    context,
                                                    controller,
                                                    child,
                                                  ) {
                                                    return SmBtn(
                                                      onPressed: () {
                                                        if (controller.isOpen) {
                                                          controller.close();
                                                        } else {
                                                          controller.open();
                                                        }
                                                      },
                                                      tooltip:
                                                          context.loc.forms,
                                                      child: const Icon(
                                                        Icons.document_scanner,
                                                      ),
                                                    );
                                                  },
                                              menuChildren: [
                                                ...visit_data.forms.map((f) {
                                                  return MenuItemButton(
                                                    child: FilterChip.elevated(
                                                      label: Text(f.name_en),
                                                      selectedColor:
                                                          Colors.amber.shade200,
                                                      selected:
                                                          f.id ==
                                                          s.selectedForm?.id,
                                                      onSelected: (value) {
                                                        if (value) {
                                                          s.selectFormItems(
                                                            visit_data
                                                                .forms_data
                                                                .firstWhere(
                                                                  (x) =>
                                                                      x.form_id ==
                                                                      f.id,
                                                                )
                                                                .form_data,
                                                            f,
                                                          );
                                                        } else {
                                                          s.selectFormItems(
                                                            null,
                                                            null,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
