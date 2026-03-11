import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

class ConcisedUser extends Equatable {
  final String id;
  final String name;
  final String email;

  const ConcisedUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ConcisedUser.fromJson(Map<String, dynamic> map) {
    return ConcisedUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, email];
}

class ConcisedUserWithFcmToken extends ConcisedUser {
  const ConcisedUserWithFcmToken({
    required super.id,
    required super.name,
    required super.email,
    required this.fcm_token,
  });

  final String? fcm_token;

  factory ConcisedUserWithFcmToken.fromRecordModel(RecordModel record) {
    return ConcisedUserWithFcmToken(
      id: record.getStringValue('id'),
      name: record.getStringValue('name'),
      email: record.getStringValue('email'),
      fcm_token: record.get<String?>('fcm_token'),
    );
  }
}
