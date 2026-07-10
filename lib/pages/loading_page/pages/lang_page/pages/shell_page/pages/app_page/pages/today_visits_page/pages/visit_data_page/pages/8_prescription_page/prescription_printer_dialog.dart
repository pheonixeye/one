// import 'package:one/assets/assets.dart';
import 'dart:async';

import 'package:one/utils/g_fonts_loader.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:one/extensions/loc_ext.dart';

class PrescriptionPrinterDialog extends StatefulWidget {
  const PrescriptionPrinterDialog({
    super.key,
    required this.dataBytes,
    required this.imageBytes,
  });
  final Uint8List dataBytes;
  final Uint8List imageBytes;

  @override
  State<PrescriptionPrinterDialog> createState() =>
      _PrescriptionPrinterDialogState();
}

class _PrescriptionPrinterDialogState extends State<PrescriptionPrinterDialog> {
  bool _imageWithData = false;

  @override
  Widget build(BuildContext context) {
    FutureOr<Uint8List> _build(PdfPageFormat format) {
      final doc = pw.Document();
      // final _font_base = await _getFontBytes('base');
      // final _font_bold = await _getFontBytes('bold');
      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            theme: pw.ThemeData.withFont(
              base: GFontsLoader.baseFont,
              bold: GFontsLoader.boldFont,
              icons: pw.Font.zapfDingbats(),
            ),
            clip: true,
            margin: pw.EdgeInsets.all(0),
            pageFormat: format,
          ),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(
                  _imageWithData ? widget.imageBytes : widget.dataBytes,
                ),
              ),
            );
          },
        ),
      );
      return doc.save();
    }

    return AlertDialog(
      backgroundColor: Colors.blue.shade50,
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.loc.printPrescription,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
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
        height: MediaQuery.sizeOf(context).height,
        width: 480,
        child: Scaffold(
          body: PdfPreview(
            initialPageFormat: PdfPageFormat.a5,
            dpi: 300,
            build: _build,
            allowPrinting: true,
            allowSharing: true,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
          ),
          floatingActionButton: SmBtn(
            onPressed: () {
              setState(() {
                _imageWithData = !_imageWithData;
              });
            },
            child: const Icon(Icons.photo_rounded),
          ),
        ),
      ),
    );
  }
}
