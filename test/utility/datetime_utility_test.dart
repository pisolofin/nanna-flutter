import 'package:flutter_test/flutter_test.dart';
import 'package:nanna/nanna.dart';

void main() {
  group('DateTime Utility', () {
    test('naDateOnly and naToDateOnly should return midnight time', () {
      final date = DateTime(2026, 7, 6, 15, 30, 45);
      final dateOnly1 = naDateOnly(date);
      final dateOnly2 = date.naToDateOnly();
      
      expect(dateOnly1, DateTime(2026, 7, 6));
      expect(dateOnly2, DateTime(2026, 7, 6));
    });

    test('naUtcDateTime and naToUtcDateTime should return UTC time', () {
      final date = DateTime(2026, 7, 6, 15, 30, 45);
      final utc1 = naUtcDateTime(date);
      final utc2 = date.naToUtcDateTime();
      
      expect(utc1.isUtc, isTrue);
      expect(utc1.year, 2026);
      expect(utc2.isUtc, isTrue);
    });

    test('toIso8601DateOnlyString should format correctly', () {
      final date = DateTime(2026, 7, 6, 15, 30);
      expect(date.toIso8601DateOnlyString(), '2026-07-06');
    });
  });
}
