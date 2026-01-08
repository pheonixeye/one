import 'package:pocketbase/pocketbase.dart';

class PocketbaseHelper {
  static final _pb = PocketBase(const String.fromEnvironment('PB_URL'));

  static PocketBase get pbBase => _pb;

  static PocketBase? _pbData;

  static PocketBase? get pbData => _pbData;

  static void initialize(String url) {
    _pbData = PocketBase(url);
  }
}
