import 'package:flutter/material.dart';
import 'package:one/core/api/documents/s3_documents_api.dart';
import 'package:one/providers/px_auth.dart';
import 'package:provider/provider.dart';
import 'package:s3_dart_lite/s3_dart_lite.dart';

class PxS3Documents extends ChangeNotifier {
  PxS3Documents(this.context) {
    _init();
  }
  final BuildContext context;

  S3DocumentsApi? _api;
  S3DocumentsApi? get api => _api;

  void _init() {
    final org = context.read<PxAuth>().organization;
    if (org != null) {
      _api = S3DocumentsApi(
        clientOptions: ClientOptions(
          endPoint: org.s3_endpoint,
          secretKey: org.s3_secret,
          accessKey: org.s3_key,
          bucket: org.s3_bucket,
          region: '',
        ),
      );
    }
  }

  Future<void> uploadDocument({
    required String objectName,
    required dynamic payload,
  }) async {
    await api?.uploadDocument(
      objectName: objectName,
      payload: payload,
    );
  }
}
