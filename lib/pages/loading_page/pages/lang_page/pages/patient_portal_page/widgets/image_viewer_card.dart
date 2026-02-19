import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/download_image.dart';
import 'package:one/providers/px_patient_portal.dart';
import 'package:one/widgets/central_loading.dart';

class ImageViewerCard extends StatefulWidget {
  const ImageViewerCard({super.key, required this.url});
  final String url;
  @override
  State<ImageViewerCard> createState() => _ImageViewerCardState();
}

class _ImageViewerCardState extends State<ImageViewerCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: PxPatientPortal.getOneDocument(objectName: widget.url),
      builder: (context, sh) {
        while (sh.connectionState == ConnectionState.waiting ||
            sh.data == null) {
          return const CentralLoading();
        }
        final _imageBytes = sh.data;
        return Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.topCenter,
          children: [
            Image.memory(_imageBytes!),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 16,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    downloadUint8ListAsFile(
                      _imageBytes,
                      widget.url.split('/').last,
                    );
                  },
                  label: Text(context.loc.download),
                  icon: const Icon(Icons.download),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
