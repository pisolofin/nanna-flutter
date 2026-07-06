import 'package:flutter_test/flutter_test.dart';
import 'package:nanna/src/utility/native.utility.dart';

void main() {
  group('Native Utility', () {
    test('convertToMap should handle Map<String, dynamic>', () {
      final map = {'key': 'value'};
      final result = convertToMap(map);
      expect(result, {'key': 'value'});
    });

    test('convertToMap should convert Map<Object?, Object?>', () {
      final map = <Object?, Object?>{'key': 'value', null: 'ignored', 'number': 1};
      final result = convertToMap(map);
      expect(result, {'key': 'value', 'number': 1});
    });

    test('convertToMap should return empty map for unsupported type', () {
      final result = convertToMap('string');
      expect(result, {});
    });
  });
}
