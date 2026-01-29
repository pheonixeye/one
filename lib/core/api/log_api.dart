import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/models/log_entry.dart';

class LogApi {
  const LogApi({required this.user_id});
  final String user_id;

  static const String collection = 'log';

  Future<void> log({
    required String item_id,
    required String collection_id,
    required String message,
  }) async {
    final log = LogEntry(
      id: '',
      item_id: item_id,
      collection_id: collection_id,
      message: message,
      user_id: user_id,
    );
    await PocketbaseHelper.pbBase
        .collection(collection)
        .create(body: log.toJson());
  }
}
