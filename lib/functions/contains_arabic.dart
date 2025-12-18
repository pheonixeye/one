bool containsArabic(String input) {
  final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]+');
  return arabicRegex.hasMatch(input);
}
