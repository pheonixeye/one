import 'package:equatable/equatable.dart';

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
