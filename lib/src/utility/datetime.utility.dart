/// Returns a DateTime with the date of the original, but time set to midnight.
DateTime naDateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Returns a DateTime with the time of the original, but date set to today.
DateTime naUtcDateTime(DateTime dateTime) {
  return DateTime.utc(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    dateTime.second,
    dateTime.millisecond,
    dateTime.microsecond,
  );
}

extension NaDateTimeExtension on DateTime {
  /// Returns a DateTime with the date of the original, but time set to midnight.
  DateTime naToDateOnly() {
    return naDateOnly(this);
  }

  /// Returns a DateTime with the time of the original, but date set to today.
  DateTime naToUtcDateTime() {
    return naUtcDateTime(this);
  }

  /// Returns an ISO-8601 only Date format representation
  /// The format is `yyyy-MM-dd`
  String toIso8601DateOnlyString() {
    return this.toIso8601String().substring(0, 10);
  }
}
