extension DatetimeExt on DateTime {
  bool get isLeapYear => year % 4 == 0;
  int get daysPerMonth {
    return switch (month) {
      1 || 3 || 5 || 7 || 8 || 10 || 12 => 31,
      2 => switch (isLeapYear) {
          true => 29,
          false => 28,
        },
      _ => 30,
    };
  }

  bool isTheSameDate(DateTime val) {
    return year == val.year && month == val.month && day == val.day;
  }
}
