import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:one/assets/assets.dart';
import 'package:one/extensions/model_url_ext.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/clinic/prescription_details.dart';

class PrescriptionPdfBuilder {
  final Clinic clinic;
  final String doc_id;
  final double dpi = 72;
  final String app_locale; //todo: check implementation

  static final Map<String, Uint8List> _imageBytesCache = {};

  static final Map<String, ByteData> _fontBytesCache = {};

  static final Map<String, PdfPageFormat> formats = {
    PrescriptionPaperSize.a5.name: PdfPageFormat.a5,
    PrescriptionPaperSize.a4.name: PdfPageFormat.a4,
  };

  PrescriptionPdfBuilder({
    required this.clinic,
    required this.doc_id,
    required this.app_locale,
  });

  late final pw.TextDirection _textDirection = switch (app_locale
      .toLowerCase()) {
    'en' => pw.TextDirection.ltr,
    'ar' => pw.TextDirection.rtl,
    _ => throw UnimplementedError(),
  };

  bool get isEnglish => app_locale.toLowerCase() == 'en';

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

  Future<Uint8List> _getImageBytes() async {
    if (_imageBytesCache[clinic.prescription_file] == null) {
      final _imgBytes = await clinic.prescImageBytes();
      _imageBytesCache[clinic.prescription_file] = _imgBytes;
      return _imgBytes;
    } else {
      return _imageBytesCache[clinic.prescription_file]!;
    }
  }

  FutureOr<Uint8List> build(PdfPageFormat format) async {
    final _bytes = await _getImageBytes();
    final _font_base = await _getFontBytes('base');
    final _font_bold = await _getFontBytes('bold');
    final _doc = pw.Document();

    final _page = pw.Page(
      pageTheme: pw.PageTheme(
        textDirection: _textDirection,
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(_font_base),
          bold: pw.Font.ttf(_font_bold),
          icons: pw.Font.ttf(_font_base),
        ),
        clip: true,
        margin: pw.EdgeInsets.all(0),
        buildBackground: (context) {
          return pw.Image(pw.MemoryImage(_bytes, dpi: dpi));
        },
        pageFormat: format,
      ),
      build: (context) {
        return pw.Center(
          child: pw.Stack(
            alignment: pw.Alignment.center,
            children: [
              ...PrescriptionDetails.initial().details.entries.map((e) {
                return pw.Positioned(
                  top: e.value.y_coord,
                  left: e.value.x_coord,
                  child: pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.SizedBox(width: 10, child: pw.Text('*')),
                      pw.Text(
                        isEnglish ? e.value.name_en : e.value.name_ar,
                        style: pw.TextStyle(fontSize: 16),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(width: 10, child: pw.Text('*')),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );

    _doc.addPage(_page);

    return _doc.save();
  }

  late final PdfPreview _preview = PdfPreview(
    pageFormats: PrescriptionPdfBuilder.formats,
    initialPageFormat: PrescriptionPdfBuilder.formats['a5'],
    build: build,
    allowPrinting: true,
    allowSharing: false,
    canChangeOrientation: false,
    canChangePageFormat: false,
    canDebug: false,
  );

  PdfPreview get widget => _preview;
}
