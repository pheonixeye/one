import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/model_url_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/clinic/prescription_details.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/logic/pdf_prescription_builder.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/floating_ax_menu_bubble.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class ClinicPrescriptionDialog extends StatefulWidget {
  const ClinicPrescriptionDialog({super.key});

  @override
  State<ClinicPrescriptionDialog> createState() =>
      _ClinicPrescriptionDialogState();
}

class _ClinicPrescriptionDialogState extends State<ClinicPrescriptionDialog>
    with TickerProviderStateMixin {
  late final TabController _controller;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  PrescriptionDetails? _state;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
      animationDuration: Duration(milliseconds: 260),
    );
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

  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _state = context.read<PxClinics>().clinic?.prescription_details;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxClinics, PxLocale>(
      builder: (context, c, l, _) {
        while (c.clinic == null) {
          return const CentralLoading();
        }
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text(context.loc.clinicPrescription)),
              if (_currentIndex == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton.outlined(
                    tooltip: context.loc.deletePrescriptionFile,
                    onPressed: () async {
                      if (c.clinic!.prescription_file == '') {
                        return;
                      }
                      final _toDeletePrescription = await showDialog<bool?>(
                        context: context,
                        builder: (context) {
                          return PromptDialog(
                            message: context.loc.deletePrescriptionFilePrompt,
                          );
                        },
                      );
                      if (_toDeletePrescription == null ||
                          _toDeletePrescription == false) {
                        return;
                      }
                      if (context.mounted) {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await c.deletePrescriptionFile();
                          },
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                  ),
                ),
              if (_currentIndex == 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton.outlined(
                    tooltip: context.loc.back,
                    onPressed: () {
                      _controller.animateTo(0);
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton.outlined(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          scrollable: false,
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: TabBarView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    border: Border.all(),
                  ),
                  //todo: Craft ui && logic
                  child: Builder(
                    builder: (context) {
                      return Scaffold(
                        body: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            switch (c.clinic!.prescription_file) {
                              '' => Align(
                                alignment: Alignment.center,
                                child: Card.outlined(
                                  elevation: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      spacing: 8,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            context.loc.noPrescriptionFileFound,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              //todo: upload file
                                              final _result = await FilePicker
                                                  .platform
                                                  .pickFiles(
                                                    type: FileType.image,
                                                    allowMultiple: false,
                                                    withData: true,
                                                  );
                                              if (_result == null) {
                                                return;
                                              }
                                              final _xfile =
                                                  _result.xFiles.first;
                                              final _bytes = await _xfile
                                                  .readAsBytes();
                                              if (context.mounted) {
                                                await shellFunction(
                                                  context,
                                                  toExecute: () async {
                                                    await c
                                                        .updatePrescriptionFile(
                                                          file_bytes: _bytes,
                                                          filename: _xfile.name,
                                                        );
                                                  },
                                                );
                                              }
                                            },
                                            label: Text(
                                              context.loc.addPrescriptionFile,
                                            ),
                                            icon: Icon(
                                              Icons.upload_file,
                                              color: Colors.green.shade100,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              _ => Align(
                                alignment: Alignment.center,
                                child: Image.network(
                                  c.clinic!.prescriptionFileUrl(),
                                ),
                              ),
                            },
                            //the file is already uploaded
                            //the state(prescription_details != null)
                            if (_state != null &&
                                c.clinic!.prescription_file != '')
                              ..._state!.details.entries.map((e) {
                                //HACK: Remove later
                                return Visibility(
                                  visible: false,
                                  child: Positioned(
                                    top: e.value.y_coord,
                                    left: e.value.x_coord,
                                    child: Draggable(
                                      onDragUpdate: (details) {
                                        setState(() {
                                          _state = _state!.updateItemDetail(
                                            key: e.key,
                                            x_coord: details.localPosition.dx,
                                            y_coord: details.localPosition.dy,
                                          );
                                        });
                                      },
                                      dragAnchorStrategy:
                                          pointerDragAnchorStrategy,
                                      feedback: Material(
                                        color: Colors.amber.shade100,
                                        child: Row(
                                          children: [
                                            MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: SizedBox(
                                                width: 20,
                                                child: const Icon(
                                                  Icons.drag_indicator,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              l.isEnglish
                                                  ? e.value.name_en
                                                  : e.value.name_ar,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: SizedBox(
                                              width: 20,
                                              child: const Icon(
                                                Icons.drag_indicator,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            l.isEnglish
                                                ? e.value.name_en
                                                : e.value.name_ar,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          ],
                        ),
                        //the state is not equal to the initial state
                        //HACK: Remove later
                        floatingActionButton: Visibility(
                          visible: false,
                          child: FloatingActionMenuBubble(
                            animation: _animation,
                            // On pressed change animation state
                            onPress: () => _animationController.isCompleted
                                ? _animationController.reverse()
                                : _animationController.forward(),
                            // Floating Action button Icon color
                            iconColor: Colors.white,
                            // Flaoting Action button Icon
                            // iconData: Icons.settings,
                            animatedIconData: AnimatedIcons.menu_close,
                            backGroundColor: Colors.amber,
                            items: [
                              Bubble(
                                title: context.loc.save,
                                iconColor: Colors.white,
                                bubbleColor: Colors.amber,
                                icon: Icons.save,
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                onPress: () async {
                                  _animationController.reverse();
                                  //todo: save updated prescriptionDetails
                                  if (_state == null ||
                                      DeepCollectionEquality.unordered().equals(
                                        _state,
                                        c.clinic?.prescription_details,
                                      )) {
                                    return;
                                  }
                                  await shellFunction(
                                    context,
                                    toExecute: () async {
                                      await c.updatePrescriptionDetails(
                                        _state!,
                                      );
                                    },
                                  );
                                },
                              ),
                              Bubble(
                                title: context.loc.viewPdfPrescription,
                                iconColor: Colors.white,
                                bubbleColor: Colors.amber,
                                icon: Icons.remove_red_eye_outlined,
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                onPress: () async {
                                  _animationController.reverse();
                                  _controller.animateTo(1);
                                  setState(() {
                                    _currentIndex = 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                //HACK: Remove later
                Visibility(
                  visible: false,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      border: Border.all(),
                    ),
                    child: Scaffold(
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PrescriptionPdfBuilder(
                          doc_id: c.api.doc_id,
                          clinic: c.clinic!,
                          app_locale: l.lang,
                        ).widget,
                      ),
                    ),
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
