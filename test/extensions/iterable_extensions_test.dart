import 'package:flutter_test/flutter_test.dart';
import 'package:nanna/nanna.dart';
import 'package:nanna/src/extensions/iterable.extensions.dart';

void main() {
  group('Iterable Extensions', () {
    test('indexWhere should return correct index', () {
      final Iterable list = ['a', 'b', 'c'];
      final index = NaIterableExtensions(list).indexWhere<String>((item) => item == 'b');
      expect(index, 1);
    });

    test('indexWhere should return -1 if not found', () {
      final Iterable list = ['a', 'b', 'c'];
      final index = NaIterableExtensions(list).indexWhere<String>((item) => item == 'd');
      expect(index, -1);
    });
  });
}
