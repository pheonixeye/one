import 'package:pdf/widgets.dart' show Font;
import 'package:printing/printing.dart' as p;

class GFontsLoader {
  static late final Font baseFont;
  static late final Font boldFont;

  static Future<void> initFonts() async {
    baseFont = await p.PdfGoogleFonts.iBMPlexSansArabicRegular();
    boldFont = await p.PdfGoogleFonts.iBMPlexSansArabicSemiBold();
  }
}
