import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanna/src/utility/file-system.utility.dart';

void main() {
  group('FileSystem Utility', () {
    test('jsonToFileAsync and jsonFromFileAsync should work', () async {
      final file = File('test_data.json');
      final data = {'key': 'value'};
      
      // Write
      await jsonToFileAsync(data, file);
      expect(await file.exists(), isTrue);
      
      // Read
      final result = await jsonFromFileAsync<Map<String, dynamic>>(
        file, 
        (jsonMap) => jsonMap
      );
      expect(result, {'key': 'value'});
      
      // Cleanup
      await file.delete();
    });

    test('jsonFromFileAsync should return null if file does not exist', () async {
      final file = File('non_existent.json');
      final result = await jsonFromFileAsync<Map<String, dynamic>>(
        file, 
        (jsonMap) => jsonMap
      );
      expect(result, isNull);
    });
  });
}
