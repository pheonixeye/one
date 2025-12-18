enum BookkeepingDirection {
  IN(
    value: 'in',
    en: 'Income',
    ar: 'وارد',
  ),
  OUT(
    value: 'out',
    en: 'Expense',
    ar: 'صادر',
  ),
  NONE(
    value: 'none',
    en: 'None',
    ar: 'بدون',
  );

  final String value;
  final String en;
  final String ar;

  const BookkeepingDirection({
    required this.value,
    required this.en,
    required this.ar,
  });

  factory BookkeepingDirection.fromString(String value) {
    return BookkeepingDirection.values.firstWhere((x) => x.value == value);
  }
}
