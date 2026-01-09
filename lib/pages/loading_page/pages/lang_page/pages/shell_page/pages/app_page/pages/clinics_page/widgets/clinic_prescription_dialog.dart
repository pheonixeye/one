import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/model_url_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';

class ClinicPrescriptionDialog extends StatefulWidget {
  const ClinicPrescriptionDialog({super.key});

  @override
  State<ClinicPrescriptionDialog> createState() =>
      _ClinicPrescriptionDialogState();
}

class _ClinicPrescriptionDialogState extends State<ClinicPrescriptionDialog> {
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
          content: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(),
            ),
            child: Stack(
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
                                  final _result = await FilePicker.platform
                                      .pickFiles(
                                        type: FileType.image,
                                        allowMultiple: false,
                                        withData: true,
                                      );
                                  if (_result == null) {
                                    return;
                                  }
                                  final _xfile = _result.xFiles.first;
                                  final _bytes = await _xfile.readAsBytes();
                                  if (context.mounted) {
                                    await shellFunction(
                                      context,
                                      toExecute: () async {
                                        await c.updatePrescriptionFile(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
