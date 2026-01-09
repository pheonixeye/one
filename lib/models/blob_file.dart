import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

class BlobFile extends Equatable {
  final String id;
  final String doc_id;
  final String name;
  final String file;

  const BlobFile({
    required this.id,
    required this.doc_id,
    required this.name,
    required this.file,
  });

  BlobFile copyWith({
    String? id,
    String? doc_id,
    String? name,
    String? file,
  }) {
    return BlobFile(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      name: name ?? this.name,
      file: file ?? this.file,
    );
  }

  factory BlobFile.fromRecordModel(RecordModel e) {
    return BlobFile(
      id: e.getStringValue('id'),
      doc_id: e.getStringValue('doc_id'),
      name: e.getStringValue('name'),
      file: e.getStringValue('file'),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
    id,
    doc_id,
    name,
    file,
  ];
}

extension PocketbaseExt on BlobFile {
  String get fileUrl =>
      '${PocketbaseHelper.pbData.baseURL}/api/files/blobs/$id/$file';
}

enum BlobNames {
  notification_sound,
  app_logo;

  @override
  String toString() {
    return name.split('.').last;
  }
}
