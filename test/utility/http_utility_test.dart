import 'package:flutter_test/flutter_test.dart';
import 'package:nanna/nanna.dart';

void main() {
  group('Http Utility', () {
    test('encodeParams should properly encode maps', () {
      final params = {
        'name': 'John Doe',
        'age': '30',
        'city': 'New York'
      };
      
      final encoded = encodeParams(params);
      expect(encoded, 'name=John%20Doe&age=30&city=New%20York');
    });
  });
}
