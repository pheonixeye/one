import 'dart:typed_data';

import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/blob_api.dart';
import 'package:one/models/blob_file.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PxBlobs extends ChangeNotifier {
  final BlobApi api;

  PxBlobs({required this.api}) {
    _init();
  }

  ApiResult<List<BlobFile>>? _result;
  ApiResult<List<BlobFile>>? get result => _result;

  final Map<String, Uint8List> _files = {};
  Map<String, Uint8List> get files => _files;

  Future<void> _init() async {
    _result = await api.fetchBlobs();
    notifyListeners();
    await _getFilesUint8Lists();
  }

  Future<void> _getFilesUint8Lists() async {
    if (_result == null) {
      return;
    }

    (_result as ApiDataResult<List<BlobFile>>).data.map((e) async {
      final _request = await http.get(Uri.parse(e.fileUrl));
      _files[e.name] = _request.bodyBytes;
      notifyListeners();
    }).toList();
  }

  Future<void> retry() async => await _init();

  Future<void> updateBlobFile(
    String id, {
    required Uint8List file_bytes,
    required String filename,
  }) async {
    await api.updateBlobFile(id, file_bytes: file_bytes, filename: filename);
    await _init();
  }
}
