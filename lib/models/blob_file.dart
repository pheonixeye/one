import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

class BlobFile extends Equatable {
  final String id;
  final String name;
  final String file;

  const BlobFile({required this.id, required this.name, required this.file});

  BlobFile copyWith({String? id, String? name, String? file}) {
    return BlobFile(
      id: id ?? this.id,
      name: name ?? this.name,
      file: file ?? this.file,
    );
  }

  factory BlobFile.fromRecordModel(RecordModel e) {
    return BlobFile(
      id: e.getStringValue('id'),
      name: e.getStringValue('name'),
      file: e.getStringValue('file'),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, file];
}

extension PocketbaseExt on BlobFile {
  String get fileUrl =>
      '${PocketbaseHelper.pb.baseURL}/api/files/blobs/$id/$file';
}

enum BlobNames {
  notification_sound,
  app_logo;

  @override
  String toString() {
    return name.split('.').last;
  }
}
