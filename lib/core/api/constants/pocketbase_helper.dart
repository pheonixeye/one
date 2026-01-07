import 'package:pocketbase/pocketbase.dart';

class PocketbaseHelper {
  static final _pb = PocketBase(const String.fromEnvironment('PB_URL'));

  static PocketBase get pbBase => _pb;

  final String? dataInstanceUrl;

  PocketbaseHelper._(this.dataInstanceUrl) {
    if (dataInstanceUrl != null) {
      _pbData = PocketBase(dataInstanceUrl!);
    }
  }

  static PocketbaseHelper instance(String? dataInstanceUrl) =>
      PocketbaseHelper._(dataInstanceUrl);

  PocketBase? _pbData;
  PocketBase? get pbData => _pbData;
}
