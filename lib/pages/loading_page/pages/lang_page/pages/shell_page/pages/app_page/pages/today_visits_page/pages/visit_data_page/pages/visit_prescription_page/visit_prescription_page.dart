import 'dart:typed_data';

import 'package:one/core/api/patient_document_api.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/model_url_ext.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/models/visits/_visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/visit_prescription_page/widgets/prescription_printer_dialog.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/providers/px_visit_prescription_state.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class VisitPrescriptionPage extends StatelessWidget {
  const VisitPrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Consumer6<
            PxAppConstants,
            PxVisits,
            PxVisitData,
            PxClinics,
            PxVisitPrescriptionState,
            PxLocale
          >(
            builder: (context, a, v, vd, c, s, l, _) {
              while (a.constants == null ||
                  v.visits == null ||
                  vd.result == null ||
                  c.result == null) {
                return const CentralLoading();
              }
              final visit_data = (vd.result as ApiDataResult<VisitData>).data;
              final visit = (v.monthlyVisits as ApiDataResult<List<Visit>>).data
                  .firstWhereOrNull((x) => x.id == visit_data.visit_id);
              final clinics = (c.result as ApiDataResult<List<Clinic>>).data;
              final clinic = clinics.firstWhereOrNull(
                (e) => e.id == visit_data.clinic_id,
              );
              if (clinic == null) {
                return CentralError(code: 1, toExecute: c.retry);
              }
              return Center(
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
                                    fit: BoxFit.contain,
                                  ),
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 420,
                              minWidth: 420,
                            ),
                            child: Screenshot(
                              controller: s.screenshotControllerWithoutImage,
                              child: Stack(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                alignment: Alignment.center,
                                fit: StackFit.expand,
                                children: [
                                  //todo: put items
                                  ...clinic.prescription_details.details.entries.map((
                                    x,
                                  ) {
                                    return Visibility(
                                      visible:
                                          s.view == PrescriptionView.regular
                                          ? s.visitPrescriptionVisibility[x
                                                .key]!
                                          : true,
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Positioned(
                                          left:
                                              s
                                                  .visitPrescriptionItemsOffset[x
                                                      .key]
                                                  ?.dx ??
                                              x.value.x_coord,
                                          top:
                                              s
                                                  .visitPrescriptionItemsOffset[x
                                                      .key]
                                                  ?.dy ??
                                              x.value.y_coord,
                                          child: Draggable(
                                            onDragUpdate: (details) {
                                              s.updateItemOffset(
                                                x.key,
                                                details.localPosition,
                                              );
                                            },
                                            dragAnchorStrategy:
                                                (draggable, context, position) {
                                                  return draggable
                                                      .feedbackOffset;
                                                },
                                            feedback: Text(x.key),
                                            child: InkWell(
                                              onDoubleTap: () {
                                                s.increaseItemFontSize(x.key);
                                              },
                                              onLongPress: () {
                                                s.decreaseItemFontSize(x.key);
                                              },
                                              child: switch (x.key) {
                                                'patient_name' => Text(
                                                  visit_data.patient.name,
                                                  style: TextStyle(
                                                    fontSize:
                                                        s.visitPrescriptionItemsFontSize[x
                                                            .key],
                                                  ),
                                                ),
                                                'visit_date' => Text(
                                                  intl.DateFormat(
                                                    'dd / MM / yyyy',
                                                    l.lang,
                                                  ).format(visit!.visit_date),
                                                  style: TextStyle(
                                                    fontSize:
                                                        s.visitPrescriptionItemsFontSize[x
                                                            .key],
                                                  ),
                                                ),
                                                'visit_type' => Text(
                                                  ' * '
                                                  '${l.isEnglish ? visit!.visit_type.name_en : visit!.visit_type.name_ar}',
                                                  style: TextStyle(
                                                    fontSize:
                                                        s.visitPrescriptionItemsFontSize[x
                                                            .key],
                                                  ),
                                                ),
                                                _ => SizedBox(),
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  if (s.view == PrescriptionView.regular)
                                    ...clinic.prescription_details.details.entries.map((
                                      x,
                                    ) {
                                      return Visibility(
                                        visible:
                                            s.visitPrescriptionVisibility[x
                                                .key] ??
                                            true,
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Positioned(
                                            left:
                                                s
                                                    .visitPrescriptionItemsOffset[x
                                                        .key]
                                                    ?.dx ??
                                                x.value.x_coord,
                                            top:
                                                s
                                                    .visitPrescriptionItemsOffset[x
                                                        .key]
                                                    ?.dy ??
                                                x.value.y_coord,
                                            child: Draggable(
                                              onDragUpdate: (details) {
                                                s.updateItemOffset(
                                                  x.key,
                                                  details.localPosition,
                                                );
                                              },
                                              dragAnchorStrategy:
                                                  (
                                                    draggable,
                                                    context,
                                                    position,
                                                  ) {
                                                    return draggable
                                                        .feedbackOffset;
                                                  },
                                              feedback: Text(
                                                l.isEnglish
                                                    ? x.value.name_en
                                                    : x.value.name_ar,
                                              ),
                                              child: InkWell(
                                                onDoubleTap: () {
                                                  s.increaseItemFontSize(x.key);
                                                },
                                                onLongPress: () {
                                                  s.decreaseItemFontSize(x.key);
                                                },
                                                child: switch (x.key) {
                                                  'visit_labs' => Text.rich(
                                                    TextSpan(
                                                      text:
                                                          'التحاليل المطلوبة\n',
                                                      children: [
                                                        ...visit_data.labs.map((
                                                          e,
                                                        ) {
                                                          return TextSpan(
                                                            text:
                                                                ' * '
                                                                '${e.name_en}\n',
                                                            children: [
                                                              if (e
                                                                  .special_instructions
                                                                  .isNotEmpty)
                                                                TextSpan(
                                                                  text:
                                                                      '(${e.special_instructions})\n',
                                                                ),
                                                            ],
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize:
                                                          s.visitPrescriptionItemsFontSize[x
                                                              .key],
                                                    ),
                                                  ),
                                                  'visit_rads' => Text.rich(
                                                    TextSpan(
                                                      text:
                                                          'الاشاعات المطلوبة\n',
                                                      children: [
                                                        ...visit_data.rads.map((
                                                          e,
                                                        ) {
                                                          return TextSpan(
                                                            text:
                                                                ' * '
                                                                '${e.name_en}\n',
                                                            children: [
                                                              if (e
                                                                  .special_instructions
                                                                  .isNotEmpty)
                                                                TextSpan(
                                                                  text:
                                                                      '(${e.special_instructions})\n',
                                                                ),
                                                            ],
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize:
                                                          s.visitPrescriptionItemsFontSize[x
                                                              .key],
                                                    ),
                                                  ),
                                                  'visit_procedures' => Text.rich(
                                                    TextSpan(
                                                      text: 'اجراءات الزيارة\n',
                                                      children: [
                                                        ...visit_data.procedures
                                                            .map((e) {
                                                              return TextSpan(
                                                                text:
                                                                    ' * '
                                                                    '${e.name_en}\n',
                                                              );
                                                            }),
                                                      ],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize:
                                                          s.visitPrescriptionItemsFontSize[x
                                                              .key],
                                                    ),
                                                  ),
                                                  'doctor_name' => Text.rich(
                                                    TextSpan(
                                                      text: '',
                                                      children: [
                                                        TextSpan(
                                                          text: l.isEnglish
                                                              ? visit
                                                                    ?.doctor
                                                                    .name_en
                                                              : visit
                                                                    ?.doctor
                                                                    .name_ar,
                                                        ),
                                                      ],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize:
                                                          s.visitPrescriptionItemsFontSize[x
                                                              .key],
                                                    ),
                                                  ),
                                                  'visit_drugs' => Text.rich(
                                                    TextSpan(
                                                      text: '',
                                                      children: [
                                                        ...visit_data.drugs.map((
                                                          e,
                                                        ) {
                                                          return TextSpan(
                                                            locale:
                                                                const Locale(
                                                                  'en',
                                                                ),
                                                            text: '',
                                                            children: [
                                                              TextSpan(
                                                                text: '\n',
                                                              ),
                                                              TextSpan(
                                                                text: 'Rx  ',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: e
                                                                    .prescriptionNameEn,
                                                              ),
                                                              TextSpan(
                                                                text: '\n',
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    '${visit_data.drug_data[e.id]}',
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize:
                                                          s.visitPrescriptionItemsFontSize[x
                                                              .key],
                                                    ),
                                                  ),
                                                  _ => Text(''),
                                                },
                                              ),
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
                                          width:
                                              s.formItemsHorizontalScale * 10,
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
                                                    text:
                                                        '${f.field_name} : \n',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                  textAlign:
                                                      s.formItemsTextAlign,
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
                                            final _docType = a
                                                .constants!
                                                .documentType
                                                .firstWhere(
                                                  (e) =>
                                                      e.name_en ==
                                                      'Prescription',
                                                );
                                            final _patientDocument =
                                                PatientDocument(
                                                  id: '',
                                                  patient_id: visit!.patient.id,
                                                  related_visit_id: visit.id,
                                                  related_visit_data_id:
                                                      visit_data.id,
                                                  document_type_id: _docType.id,
                                                  document: '',
                                                );
                                            await PatientDocumentApi(
                                              patient_id: visit.patient.id,
                                            ).addPatientDocument(
                                              _patientDocument,
                                              _bytesWithImage!,
                                              '${intl.DateFormat('dd_MM_yyyy', 'en').format(DateTime.now())}.jpg',
                                            );
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
                                      children: [
                                        if (s.view == PrescriptionView.regular)
                                          ...clinic
                                              .prescription_details
                                              .details
                                              .entries
                                              .map((e) {
                                                if (e.key == 'medical_report' ||
                                                    e.key ==
                                                        'referral_report') {
                                                  return const SizedBox();
                                                }
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: SmBtn(
                                                    tooltip: l.isEnglish
                                                        ? e.value.name_en
                                                        : e.value.name_ar,
                                                    onPressed: () {
                                                      s.toggleVisibility(e.key);
                                                    },
                                                    child: Text(
                                                      e.value.name_en
                                                          .split(' ')[1][0]
                                                          .toUpperCase(),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        if (s.view == PrescriptionView.forms)
                                          ...visit_data.forms.map((f) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: FilterChip.elevated(
                                                label: Text(f.name_en),
                                                selectedColor:
                                                    Colors.amber.shade200,
                                                selected:
                                                    f.id == s.selectedForm?.id,
                                                onSelected: (value) {
                                                  if (value) {
                                                    s.selectFormItems(
                                                      visit_data.forms_data
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
                                    if (context.isMobile)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(Icons.arrow_left),
                                          const Icon(Icons.arrow_right),
                                        ],
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
              );
            },
          ),
    );
  }
}
