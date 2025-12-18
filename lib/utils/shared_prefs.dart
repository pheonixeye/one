import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferencesAsync asyncPrefs;

void initAsyncPrefs() {
  asyncPrefs = SharedPreferencesAsync();
}
