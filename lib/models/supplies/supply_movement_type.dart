enum SupplyMovementType {
  OUT_IN(
    en: 'out_to_in',
    ar: 'وارد',
  ),
  IN_OUT(
    en: 'in_to_out',
    ar: 'صادر',
  ),
  IN_IN(
    en: 'in_to_in',
    ar: 'حركة داخلية',
  );

  final String en;
  final String ar;

  const SupplyMovementType({
    required this.en,
    required this.ar,
  });

  factory SupplyMovementType.fromString(String value) {
    return switch (value) {
      'in_to_in' => IN_IN,
      'in_to_out' => IN_OUT,
      'out_to_in' => OUT_IN,
      _ => throw UnimplementedError(),
    };
  }
}
