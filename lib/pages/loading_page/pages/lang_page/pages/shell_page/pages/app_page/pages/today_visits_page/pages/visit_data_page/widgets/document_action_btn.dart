import 'package:flutter/cupertino.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/download_image.dart';
import 'package:one/functions/print_image_as_pdf.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/image_view_download_dialog.dart';
import 'package:one/providers/px_locale.dart';
import 'package:flutter/material.dart';
import 'package:one/providers/px_s3_documents.dart';
import 'package:provider/provider.dart';

class DocumentActionBtn extends StatelessWidget {
  const DocumentActionBtn({super.key, required this.document});
  final PatientDocument document;

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxS3Documents, PxLocale>(
      builder: (context, s3, l, _) {
        while (s3.document == null) {
          return const CupertinoActivityIndicator(
            radius: 8,
          );
        }
        final _data = s3.document;

        return PopupMenuButton(
          offset: l.isEnglish ? Offset(55, 55) : Offset(-55, 55),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.open_in_full_rounded),
                  title: Text(context.loc.viewDocument),
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) {
                        return ImageViewDownloadDialog(
                          data: _data,
                          document: document,
                        );
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
                    downloadUint8ListAsFile(
                      _data,
                      document.document_url.split('/').last,
                    );
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
                tag: document.id,
                child: Image.memory(
                  _data!,
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
