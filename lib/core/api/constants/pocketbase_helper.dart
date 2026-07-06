import 'package:pocketbase/pocketbase.dart';

class PocketbaseHelper {
  factory PocketbaseHelper() {
    return _instance;
  }

  PocketbaseHelper._();

  static final _instance = PocketbaseHelper._();

  static final _pb = PocketBase(const String.fromEnvironment('PB_URL'));

  static PocketBase get pbBase => _pb;

  PocketBase? _pbData;

  PocketBase get pbData => _pbData!;

  void initialize(String url) {
    nullifyData();
    _pbData = PocketBase(url);
  }

  PocketBase? _pbPortal;

  PocketBase get pbPortal => _pbPortal!;

  void initializedPortalPb(String url) {
    nullifyPortal();
    _pbPortal = PocketBase(url);
  }

  void nullifyData() {
    _pbData = null;
  }

  void nullifyPortal() {
    _pbPortal = null;
  }
}
