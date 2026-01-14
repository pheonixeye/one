import 'dart:typed_data';

import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/download_image.dart';
import 'package:flutter/material.dart';
import 'package:one/models/patient_document/patient_document.dart';

class ImageViewDownloadDialog extends StatelessWidget {
  const ImageViewDownloadDialog({
    super.key,
    required this.data,
    required this.document,
  });
  final Uint8List data;
  final PatientDocument document;
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
              tag: document.id,
              child: Image.memory(
                data,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                key: UniqueKey(),
                onPressed: () async {
                  downloadUint8ListAsFile(
                    data,
                    document.document_url.split('/').last,
                  );
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
