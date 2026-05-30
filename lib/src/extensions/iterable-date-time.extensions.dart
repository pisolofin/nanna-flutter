extension NaIterableDateTimeExtensions on Iterable<DateTime> {
  /// Returns max value of list.
  /// If list is empty returns null.
  DateTime? maxDateTime() {
    if (this.isEmpty) {
      return null;
    }
    if (this.length == 1) {
      return this.first;
    }

    return this.reduce((DateTime currentDate, DateTime nextDate) {
      if (currentDate.isAfter(nextDate)) {
        return currentDate;
      } else {
        return nextDate;
      }
    });
  }
}
