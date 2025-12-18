import 'package:pocketbase/pocketbase.dart';

class AuthException implements Exception {
  final ClientException clientException;

  AuthException(this.clientException)
      : message = clientException.response['message'],
        details = ((clientException.response['data'] as Map<String, dynamic>)
            .entries
            .firstOrNull
            ?.value as Map<String, dynamic>?)?['message'];

  final String message;
  final String? details;

  @override
  String toString() {
    return '$message ${details ?? ''}';
  }
}
