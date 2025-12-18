import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';

final Map<String, ByteData> _fontBytesCache = {};

Future<ByteData> _getFontBytes(String key) async {
  if (_fontBytesCache[key] == null) {
    final _bytes = switch (key) {
      'base' => await rootBundle.load(AppAssets.ibm_base),
      'bold' => await rootBundle.load(AppAssets.ibm_bold),
      _ => throw UnimplementedError(),
    };
    _fontBytesCache[key] = _bytes;
    return _bytes;
  } else {
    return _fontBytesCache[key]!;
  }
}

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
    Future<Uint8List> _build(PdfPageFormat format) async {
      final doc = pw.Document();
      final _font_base = await _getFontBytes('base');
      final _font_bold = await _getFontBytes('bold');
      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            theme: pw.ThemeData.withFont(
              base: pw.Font.ttf(_font_base),
              bold: pw.Font.ttf(_font_bold),
              icons: pw.Font.ttf(_font_base),
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
