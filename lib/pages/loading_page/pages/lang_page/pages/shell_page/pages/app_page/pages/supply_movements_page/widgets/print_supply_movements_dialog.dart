import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/supplies/supply_movement.dart';
import 'package:one/models/supplies/supply_movement_type.dart';

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

class PrintSupplyMovementsDialog extends StatefulWidget {
  const PrintSupplyMovementsDialog({
    super.key,
    required this.movements,
    required this.fromDate,
    required this.toDate,
  });
  final List<SupplyMovement> movements;
  final DateTime fromDate;
  final DateTime toDate;

  @override
  State<PrintSupplyMovementsDialog> createState() =>
      _PrintSupplyMovementsDialogState();
}

class _PrintSupplyMovementsDialogState
    extends State<PrintSupplyMovementsDialog> {
  Future<Uint8List> _build(PdfPageFormat format) async {
    final doc = pw.Document();
    final _font_base = await _getFontBytes('base');
    final _font_bold = await _getFontBytes('bold');
    final _perPage = 15;

    Map<int, List<SupplyMovement>> _splitted = {};

    int _pages = 0;

    if (widget.movements.length < _perPage) {
      _pages = 1;
    } else {
      _pages = (widget.movements.length / _perPage).round();
    }

    for (var i = 0; i < _pages; i++) {
      final _from = i * _perPage;

      final _to = ((i + 1) * _perPage) >= (widget.movements.length + 1)
          ? null
          : (i + 1) * _perPage;

      _splitted[i] = widget.movements.sublist(_from, _to);
    }

    pw.Page _buildPage(List<SupplyMovement> _splitted, int page) => pw.Page(
      pageTheme: pw.PageTheme(
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(_font_base),
          bold: pw.Font.ttf(_font_bold),
          icons: pw.Font.zapfDingbats(),
        ),
        orientation: pw.PageOrientation.landscape,
        textDirection: pw.TextDirection.rtl,
        clip: true,
        margin: pw.EdgeInsets.all(0),
        pageFormat: format,
      ),
      build: (pw.Context ctx) {
        return pw.Center(
          child: pw.Column(
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('تقرير حركة المستلزمات'),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(
                  "(${DateFormat('dd - MM - yyyy', 'ar').format(widget.fromDate)}) - (${DateFormat('dd - MM - yyyy', 'ar').format(widget.toDate)})",
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(
                  "صفحة -(${page.toString().toForcedArabicNumber(context)})-",
                ),
              ),
              pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('مسلسل', textAlign: pw.TextAlign.center),
                      pw.Text("التاريخ", textAlign: pw.TextAlign.center),
                      pw.Text("المستلزم", textAlign: pw.TextAlign.center),
                      pw.Text("العيادة", textAlign: pw.TextAlign.center),
                      pw.Text('اتجاه الحركة', textAlign: pw.TextAlign.center),
                      pw.Text("سبب الحركة", textAlign: pw.TextAlign.center),
                      pw.Text('كمية الحركة', textAlign: pw.TextAlign.center),
                      pw.Text("سعر الحركة", textAlign: pw.TextAlign.center),
                      pw.Text('تلقائي', textAlign: pw.TextAlign.center),
                      pw.Text("بواسطة", textAlign: pw.TextAlign.center),
                    ],
                  ),
                  ..._splitted.map((x) {
                    final _index = widget.movements.indexOf(x);

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text(
                            '${_index + 1}'.toForcedArabicNumber(context),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Text(
                          DateFormat('dd - MM - yyyy', 'ar').format(x.created),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          x.supply_item.name_ar,
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          x.clinic.name_ar,
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          SupplyMovementType.fromString(x.movement_type).ar,
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(x.reason, textAlign: pw.TextAlign.center),
                        pw.Text(
                          '${x.movement_quantity} ${x.supply_item.unit_ar}'
                              .toForcedArabicNumber(context),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          '${x.movement_amount} ${context.loc.egp}'
                              .toForcedArabicNumber(context),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            x.auto_add ? '3x2714'[5] : '3x2716'[5],
                            style: pw.TextStyle(
                              font: pw.Font.zapfDingbats(),
                              fontFallback: [pw.Font.zapfDingbats()],
                            ),
                            textDirection: pw.TextDirection.rtl,
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Text(
                          x.added_by.email,
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );

    _splitted.entries.map((x) {
      doc.addPage(_buildPage(x.value, x.key + 1), index: x.key);
    }).toList();

    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade50,
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.loc.printSupplyMovements,
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
            initialPageFormat: PdfPageFormat.a4,
            dpi: 300,
            build: _build,
            allowPrinting: true,
            allowSharing: true,
            canChangeOrientation: true,
            canChangePageFormat: false,
            canDebug: false,
          ),
        ),
      ),
    );
  }
}
