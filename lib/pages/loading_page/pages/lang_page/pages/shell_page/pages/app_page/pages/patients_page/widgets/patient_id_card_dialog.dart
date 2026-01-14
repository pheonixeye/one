import 'package:one/functions/download_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/patient.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/paient_id_card_printer_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class PatientIdCardDialog extends StatefulWidget {
  const PatientIdCardDialog({super.key, required this.patient});
  final Patient patient;

  @override
  State<PatientIdCardDialog> createState() => _PatientIdCardDialogState();
}

class _PatientIdCardDialogState extends State<PatientIdCardDialog> {
  late final ScreenshotController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScreenshotController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.patientCard)),
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
      content: Screenshot(
        controller: _controller,
        child: Consumer2<PxAuth, PxLocale>(
          builder: (context, auth, l, _) {
            final _org = auth.organization;
            while (_org == null) {
              return const CentralLoading();
            }
            return SizedBox(
              width: 360,
              height: 220,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card.outlined(
                    elevation: 6,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(context.loc.idCard),
                              Text(
                                l.isEnglish ? _org.name_en : _org.name_ar,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: QrImageView.withQr(
                                  qr: QrCode.fromData(
                                    data: widget.patient.id,
                                    errorCorrectLevel: QrErrorCorrectLevel.Q,
                                  ),
                                  embeddedImage: AssetImage(AppAssets.icon),
                                  dataModuleStyle: QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.circle,
                                    color: Colors.black,
                                  ),
                                  eyeStyle: QrEyeStyle(
                                    eyeShape: QrEyeShape.circle,
                                    color: Colors.blue,
                                  ),
                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: Size(50, 50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                context.loc.name,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(widget.patient.name),
                              SizedBox(height: 4),
                              Text(
                                context.loc.dateOfBirth,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                DateFormat(
                                  'dd - MM - yyyy',
                                  l.lang,
                                ).format(DateTime.parse(widget.patient.dob)),
                              ),
                              SizedBox(height: 4),
                              Text(
                                context.loc.mobileNumber,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(widget.patient.phone),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () async {
            final _data = await _controller.capture();
            if (_data != null && context.mounted) {
              await showDialog(
                context: context,
                builder: (context) {
                  return PatientIdCardPrinterDialog(dataBytes: _data);
                },
              );
            }
          },
          label: Text(context.loc.print),
          icon: Icon(Icons.print, color: Colors.green.shade100),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            final _data = await _controller.capture();
            if (_data != null && context.mounted) {
              //todo: download image card
              downloadUint8ListAsFile(_data, widget.patient.name);
            }
          },
          label: Text(context.loc.download),
          icon: Icon(FontAwesomeIcons.download, color: Colors.green.shade100),
        ),
      ],
    );
  }
}
