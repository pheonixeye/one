import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageViewDialog extends StatelessWidget {
  const ImageViewDialog({
    super.key,
    required this.imageBytes,
  });
  final Uint8List imageBytes;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Spacer(),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
          SizedBox(width: 10),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width / 2,
        height: MediaQuery.sizeOf(context).height / 2,
        child: Image.memory(imageBytes),
      ),
    );
  }
}
