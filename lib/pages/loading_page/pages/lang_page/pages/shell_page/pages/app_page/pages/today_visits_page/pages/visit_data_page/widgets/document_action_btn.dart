import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/download_image.dart';
import 'package:one/functions/print_image_as_pdf.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient_document/expanded_patient_document.dart';
import 'package:one/models/whatsapp_models/whatsapp_image_request.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/image_view_download_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_whatsapp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DocumentActionBtn extends StatelessWidget {
  const DocumentActionBtn({super.key, required this.document});
  final ExpandedPatientDocument document;

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return PopupMenuButton(
          offset: l.isEnglish ? Offset(55, 55) : Offset(-55, 55),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Consumer<PxWhatsapp>(
                  builder: (context, w, _) {
                    return ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      leading: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                      ),
                      title: Text(context.loc.sendViaWhatsapp),
                      onTap: () async {
                        //todo: send via whatsapp
                        final _request = WhatsappImageRequest(
                          phone: document.patient.phone,
                          caption:
                              document.visit?.visit_date.toIso8601String() ??
                              '',
                          image: await document.documentUint8List(),
                        );
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await w.sendImage(_request);
                            },
                          );
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      subtitle: const Divider(),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.open_in_full_rounded),
                  title: Text(context.loc.viewDocument),
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) {
                        return ImageViewDownloadDialog(document: document);
                      },
                    ).whenComplete(() {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  subtitle: const Divider(),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.print),
                  title: Text(context.loc.print),
                  onTap: () async {
                    //todo: print Document
                    final _data = await document.documentUint8List();
                    await printImageAsPdf(_data);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  subtitle: const Divider(),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.download),
                  title: Text(context.loc.download),
                  onTap: () async {
                    final _data = await document.documentUint8List();
                    downloadUint8ListAsFile(_data, document.document);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  subtitle: const Divider(),
                ),
              ),
            ];
          },
          child: Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: document.imageUrl,
                child: CachedNetworkImage(
                  imageUrl: document.imageUrl,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
