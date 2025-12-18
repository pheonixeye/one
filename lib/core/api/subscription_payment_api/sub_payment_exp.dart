class CodedException implements Exception {
  final int code;
  final String message;

  CodedException({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return '$code : $message';
  }
}
