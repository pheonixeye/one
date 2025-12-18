import 'package:one/extensions/loc_ext.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPatientQrDialog extends StatefulWidget {
  const ScanPatientQrDialog({super.key});

  @override
  State<ScanPatientQrDialog> createState() => _ScanPatientQrDialogState();
}

class _ScanPatientQrDialogState extends State<ScanPatientQrDialog> {
  late final MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(context.loc.scanQrCode)),
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
        child: MobileScanner(
          controller: controller,
          onDetect: (barcodes) {
            // print(barcodes);
            if (barcodes.barcodes.isNotEmpty) {
              Navigator.pop(context, barcodes.barcodes.first.displayValue);
            }
          },
        ),
      ),
    );
  }
}
