import 'package:flutter_test/flutter_test.dart';
import 'package:nanna/nanna.dart';

void main() {
  group('NaSyncCancelToken Tests', () {
    test('starts as not cancelled and updates to cancelled', () {
      final token = NaSyncCancelToken();
      expect(token.isCancelled, isFalse);

      token.cancel();
      expect(token.isCancelled, isTrue);
    });
  });
}
