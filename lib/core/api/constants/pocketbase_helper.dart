import 'package:pocketbase/pocketbase.dart';

class PocketbaseHelper {
  static final _pb = PocketBase(const String.fromEnvironment('PB_URL'));

  static PocketBase get pb => _pb;
}
