import 'dart:convert';
import 'dart:typed_data' show ByteData, Uint8List;

import 'package:one/assets/assets.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/extensions/visit_ext.dart';
import 'package:one/models/blob_file.dart';
import 'package:one/models/bookkeeping/bookkeeping_item_dto.dart';
import 'package:one/models/reciept_info.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_blobs.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_one_visit_bookkeeping.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

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

class RecieptPrepareDialog extends StatefulWidget {
  const RecieptPrepareDialog({
    super.key,
    required this.visit,
    required this.info,
  });
  final Visit visit;
  final RecieptInfo info;

  @override
  State<RecieptPrepareDialog> createState() => _RecieptPrepareDialogState();
}

class _RecieptPrepareDialogState extends State<RecieptPrepareDialog> {
  ByteData? _logoBytes;
  Uint8List? _logoBlobBytes;

  @override
  void initState() {
    super.initState();
    _loadLogo();
  }

  Future<void> _loadLogo() async {
    final _b = context.read<PxBlobs>();

    _logoBytes = await rootBundle.load(AppAssets.icon);

    if (_b.files[BlobNames.app_logo.toString()] != null &&
        _b.files[BlobNames.app_logo.toString()]!.isNotEmpty) {
      _logoBlobBytes = _b.files[BlobNames.app_logo.toString()]!;
    }
  }

  pw.Widget _buildInfoRow(String title, String info) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.SizedBox(width: 16),
        pw.Text(
          title,
          style: pw.TextStyle(
            decoration: pw.TextDecoration.underline,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(' : '),
        pw.SizedBox(width: 16),
        pw.Text(info),
      ],
    );
  }

  Future<Uint8List> _build(
    PdfPageFormat format,
    List<BookkeepingItemDto> data,
    RecieptInfo info,
  ) async {
    final doc = pw.Document();
    final _font_base = await _getFontBytes('base');
    final _font_bold = await _getFontBytes('bold');

    pw.Page _buildPage() => pw.Page(
      pageTheme: pw.PageTheme(
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(_font_base),
          bold: pw.Font.ttf(_font_bold),
          icons: pw.Font.zapfDingbats(),
        ),
        orientation: pw.PageOrientation.portrait,
        textDirection: pw.TextDirection.rtl,
        clip: true,
        margin: pw.EdgeInsets.all(0),
        pageFormat: format,
      ),
      build: (pw.Context ctx) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.ConstrainedBox(
                  constraints: pw.BoxConstraints(maxHeight: 100, maxWidth: 100),
                  child: pw.Builder(
                    builder: (_) {
                      if (_logoBlobBytes == null) {
                        return pw.Image(
                          pw.MemoryImage(
                            _logoBytes == null
                                ? Uint8List(0)
                                : Uint8List.sublistView(_logoBytes!),
                          ),
                          width: 100,
                          height: 100,
                          dpi: 300,
                          fit: pw.BoxFit.cover,
                        );
                      } else {
                        return pw.Image(
                          pw.MemoryImage(_logoBlobBytes!),
                          width: 100,
                          height: 100,
                          dpi: 300,
                          fit: pw.BoxFit.cover,
                        );
                      }
                    },
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  info.title,
                  // 'عيادات اليفيا',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  info.subtitle,
                  // 'لعلاج الالام',
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  width: 80,
                  height: 30,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    'ايصال مدفوعات',
                    style: pw.TextStyle(fontSize: 12),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              _buildInfoRow(
                'تاريخ الزيارة',
                DateFormat(
                  'dd - MM - yyyy',
                  'ar',
                ).format(widget.visit.visit_date),
              ),
              pw.SizedBox(height: 4),
              _buildInfoRow('اسم المستفيد', 'ا/ ${widget.visit.patient.name}'),
              pw.SizedBox(height: 4),
              _buildInfoRow(
                'رقم الموبايل',
                widget.visit.patient.phone.toArabicNumber(context),
              ),
              pw.SizedBox(height: 4),
              _buildInfoRow(
                'الطبيب المعالج',
                'د/ ${widget.visit.doctor.name_ar}',
              ),
              pw.SizedBox(height: 4),
              _buildInfoRow('نوع الزيارة', widget.visit.visit_type.name_ar),
              pw.SizedBox(height: 4),
              _buildInfoRow('حالة الزيارة', widget.visit.visit_status.name_ar),
              pw.SizedBox(height: 4),
              _buildInfoRow('الموعد', widget.visit.formattedShift(context)),
              pw.SizedBox(height: 4),
              _buildInfoRow(
                'اجمالي المدفوع',
                '${data.map((e) => e.amount).toList().fold<double>(0, (a, b) => a + b)} ${context.loc.egp}'
                    .toForcedArabicNumber(context),
              ),
              pw.SizedBox(height: 12),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'مع اخلص تمنياتنا بالشفاء العاجل',
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  info.footer,
                  // 'عيادات اليفيا لعلاج الالم',
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  info.address,
                  // '٧٤ شارع الملتقي العربي - مساكن شيراتون - الدور الثالث',
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  info.phone,
                  // '01016075325',
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  width: 58,
                  height: 58,
                  padding: pw.EdgeInsets.all(8),
                  child: pw.BarcodeWidget.fromBytes(
                    data: utf8.encode(widget.visit.patient_id),
                    barcode: pw.Barcode.fromType(pw.BarcodeType.QrCode),
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
            ],
          ),
        );
      },
    );

    doc.addPage(_buildPage());

    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxOneVisitBookkeeping, PxLocale>(
      builder: (context, b, l, _) {
        while (b.result == null) {
          return const CentralLoading();
        }
        while (b.result is ApiErrorResult) {
          return CentralError(
            code: (b.result as ApiErrorResult).errorCode,
            toExecute: b.retry,
          );
        }
        final _data =
            (b.result as ApiDataResult<List<BookkeepingItemDto>>).data;
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.printReciept,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '(${widget.visit.patient.name})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
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
            width: MediaQuery.sizeOf(context).width,
            child: Scaffold(
              body: PdfPreview(
                initialPageFormat: PdfPageFormat.roll80,
                pageFormats: {
                  'roll-80mm': PdfPageFormat.roll80,
                  'roll-57mm': PdfPageFormat.roll57,
                  'A4': PdfPageFormat.a4,
                  'A5': PdfPageFormat.a5,
                },
                dpi: 300,
                build: (pageFormat) async {
                  return _build(pageFormat, _data, widget.info);
                },
                allowPrinting: true,
                allowSharing: true,
                canChangeOrientation: true,
                canChangePageFormat: true,
                canDebug: false,
              ),
            ),
          ),
        );
      },
    );
  }
}
