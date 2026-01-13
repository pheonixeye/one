import 'package:s3_dart_lite/s3_dart_lite.dart';

class S3DocumentsApi {
  final ClientOptions clientOptions;
  Client? _client;

  S3DocumentsApi({
    required this.clientOptions,
  }) {
    _client = Client(clientOptions);
    assert(_client != null);
  }

  Future<String> uploadDocument({
    required String objectName,
    required dynamic payload,
  }) async {
    await _client?.putObject(
      objectName,
      payload,
    );
    return objectName;
  }
}
