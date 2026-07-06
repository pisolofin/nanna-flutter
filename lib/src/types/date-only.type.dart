import '../utility/datetime.utility.dart';

class DateOnly {
  late final DateTime _internalDate;

  DateOnly(DateTime initialDate) {
    _internalDate = DateTime(initialDate.year, initialDate.month, initialDate.day);
  }

  /// Zero date
  static final DateOnly zero = DateOnly(DateTime(0));

  int get year  => _internalDate.year;
  int get month => _internalDate.month;
  int get day   => _internalDate.day;

  /// Whether this [DateTime] occurs before [other].
  bool isBefore(DateOnly comparisonDate) {
    if (_internalDate.isBefore(comparisonDate._internalDate)) {
      return true;
    }else {
      return false;
    }
  }

  /// Whether this [DateTime] occurs after [other].
  bool isAfter(DateOnly comparisonDate) {
    if (_internalDate.isAfter(comparisonDate._internalDate)) {
      return true;
    }else {
      return false;
    }
  }

  /// Whether this [DateTime] occurs at the same moment as [other].
  bool isAtSameMomentAs(DateOnly comparisonDate) {
    if (_internalDate.isAtSameMomentAs(comparisonDate._internalDate)) {
      return true;
    }else {
      return false;
    }
  }

  ///Returns a new [DateTime] instance with [days] added to this [DateTime].
  DateOnly addDays(int days) {
    return DateOnly(_internalDate.add(Duration(days: days)));
  }

  /// Converts to DateTime ad zero time
  DateTime toDateTime() {
    return _internalDate;
  }

  /// Returns an ISO-8601 only Date format representation
  /// The format is `yyyy-MM-dd`
  String toIso8601String() {
    return _internalDate.toIso8601DateOnlyString();
  }

  /// Compares this DateTime object to [other].
  int compareTo(DateOnly other) {
    return _internalDate.compareTo(other._internalDate);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DateOnly && _internalDate.isAtSameMomentAs(other._internalDate);
  }

  @override
  int get hashCode => _internalDate.hashCode;

  @override
  String toString() {
    return this.toIso8601String();
  }
}
