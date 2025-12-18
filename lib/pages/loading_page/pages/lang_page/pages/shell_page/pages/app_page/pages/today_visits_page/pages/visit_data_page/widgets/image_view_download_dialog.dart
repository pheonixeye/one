import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/download_image.dart';
import 'package:one/models/patient_document/expanded_patient_document.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewDownloadDialog extends StatelessWidget {
  const ImageViewDownloadDialog({super.key, required this.document});
  final ExpandedPatientDocument document;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
        child: Stack(
          children: [
            Hero(
              tag: document.imageUrl,
              child: CachedNetworkImage(
                imageUrl: document.imageUrl,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                key: UniqueKey(),
                onPressed: () async {
                  final _data = await document.documentUint8List();
                  downloadUint8ListAsFile(_data, document.document);
                },
                label: Text(context.loc.download),
                icon: const Icon(Icons.download),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
