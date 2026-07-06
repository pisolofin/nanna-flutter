extension DateTimeExtensions on DateTime {
  DateTime extractDateOnly() {
    return DateTime(this.year, this.month, this.day);
  }

  /// Returns if it's same day as target date
  bool isSameDay(DateTime targetDate) {
    if (this.year == targetDate.year && this.month == targetDate.month && this.day == targetDate.day) {
      return true;
    }else {
      return false;
    }
  }
}
