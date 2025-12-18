import 'package:flutter/widgets.dart' show ChangeNotifier, Locale;
import 'package:one/functions/dprint.dart';
import 'package:one/utils/shared_prefs.dart';

class PxLocale extends ChangeNotifier {
  static Locale _locale = const Locale("en");
  Locale get locale => _locale;

  void setLocale() {
    _locale = Locale(_lang);
    notifyListeners();
    dprint("PxLocale().setLocale($_locale)");
  }

  static String _lang = 'en';
  String get lang => _lang;
  static String get langStatic => _lang;

  Future<void> setLang(String value) async {
    _lang = value;
    await asyncPrefs.setString('lang', _lang);
    notifyListeners();
  }

  bool get isEnglish => lang == 'en' && locale == const Locale("en");
}
