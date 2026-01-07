import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/models/log_entry.dart';
import 'package:one/providers/px_auth.dart';

class LogApi {
  const LogApi();

  static const String collection = 'log';

  static Future<void> log({
    required String item_id,
    required String collection_id,
    required String message,
  }) async {
    final log = LogEntry(
      id: '',
      item_id: item_id,
      collection_id: collection_id,
      message: message,
      user_id: PxAuth.doc_id_static_getter,
    );
    await PocketbaseHelper.pbBase
        .collection(collection)
        .create(body: log.toJson());
  }
}
