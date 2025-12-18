enum VisitsFilter {
  no_filter(
    en: 'No Filter',
    ar: 'بدون',
  ),
  by_doctor(
    en: 'By Doctor',
    ar: 'حسب الطبيب',
  ),
  by_clinic(
    en: 'By Clinic',
    ar: 'حسب العيادة',
  );

  final String en;
  final String ar;

  const VisitsFilter({
    required this.en,
    required this.ar,
  });
}
