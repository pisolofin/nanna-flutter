import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nanna/src/storage/preferences.service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NaPreferences.initAsync();
  });

  group('NaPreferences Tests', () {
    test('String operations work correctly', () async {
      await NaPreferences.setString('test_string', 'hello');
      expect(NaPreferences.getString('test_string'), 'hello');
    });

    test('Int operations work correctly', () async {
      await NaPreferences.setInt('test_int', 42);
      expect(NaPreferences.getInt('test_int'), 42);
    });

    test('Double operations work correctly', () async {
      await NaPreferences.setDouble('test_double', 3.14);
      expect(NaPreferences.getDouble('test_double'), 3.14);
    });

    test('Bool operations work correctly', () async {
      await NaPreferences.setBool('test_bool', true);
      expect(NaPreferences.getBool('test_bool'), true);
    });

    test('StringList operations work correctly', () async {
      final list = ['a', 'b', 'c'];
      await NaPreferences.setStringList('test_list', list);
      expect(NaPreferences.getStringList('test_list'), list);
    });

    test('remove and clear work correctly', () async {
      await NaPreferences.setString('key1', 'val1');
      await NaPreferences.setString('key2', 'val2');

      await NaPreferences.remove('key1');
      expect(NaPreferences.getString('key1'), isNull);
      expect(NaPreferences.getString('key2'), 'val2');

      await NaPreferences.clear();
      expect(NaPreferences.getString('key2'), isNull);
    });
  });
}
