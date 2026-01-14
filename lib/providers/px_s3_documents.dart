import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:one/core/api/documents/s3_documents_api.dart';
import 'package:one/providers/px_auth.dart';
import 'package:provider/provider.dart';
import 'package:s3_dart_lite/s3_dart_lite.dart';

class PxS3Documents extends ChangeNotifier {
  PxS3Documents({
    required this.context,
    this.state = S3DocumentsPxState.not_fetch,
    this.objectName,
  }) {
    _init();
  }
  final BuildContext context;
  final S3DocumentsPxState state;
  final String? objectName;

  static S3DocumentsApi? _api;
  S3DocumentsApi? get api => _api;

  Uint8List? _document;
  Uint8List? get document => _document;

  Future<void> _init() async {
    final org = context.read<PxAuth>().organization;
    if (org != null && _api == null) {
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
    if (state == S3DocumentsPxState.fetch) {
      await fetchDocument();
    }
  }

  Future<String> uploadDocument({
    required String objectName,
    required dynamic payload,
  }) async {
    try {
      return await api!.uploadDocument(
        objectName: objectName,
        payload: payload,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List?> _getDocument({
    required String objectName,
  }) async {
    try {
      return await api!.getDocument(
        objectName: objectName,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchDocument() async {
    if (objectName == null) {
      return;
    }
    _document = await _getDocument(objectName: objectName!);
    notifyListeners();
  }
}

enum S3DocumentsPxState { fetch, not_fetch }
