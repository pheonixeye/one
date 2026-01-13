import 'dart:typed_data';

import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/blob_file.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

@PbData()
class BlobApi {
  const BlobApi({
    required this.doc_id,
  });

  final String doc_id;
  final _collection = 'blobs';

  Future<ApiResult<List<BlobFile>>> fetchBlobs() async {
    try {
      final _result = await PocketbaseHelper.pbData
          .collection(_collection)
          .getFullList(
            filter: "doc_id = '$doc_id'",
          );

      if (_result.isEmpty) {
        BlobNames.values.map((b) async {
          await PocketbaseHelper.pbData
              .collection(_collection)
              .create(
                body: {
                  'doc_id': doc_id,
                  'name': b.name,
                },
              );
        }).toList();
      }

      final _blobs = _result.map((e) => BlobFile.fromRecordModel(e)).toList();

      return ApiDataResult<List<BlobFile>>(data: _blobs);
    } on ClientException catch (e) {
      return ApiErrorResult<List<BlobFile>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<void>> updateBlobFile(
    String id, {
    required Uint8List file_bytes,
    required String filename,
  }) async {
    try {
      await PocketbaseHelper.pbData
          .collection(_collection)
          .update(
            id,
            files: [
              http.MultipartFile.fromBytes(
                'file',
                file_bytes,
                filename: filename,
              ),
            ],
          );
      return ApiDataResult(data: null);
    } on ClientException catch (e) {
      return ApiErrorResult<void>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
