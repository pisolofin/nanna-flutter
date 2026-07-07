import 'package:flutter_test/flutter_test.dart';
import 'package:nanna/src/routes/configuration/routes.models.dart';

void main() {
  group('Routes Models', () {
    test('naJoinPaths should handle slashes properly', () {
      expect(naJoinPaths('a', 'b'), 'a/b');
      expect(naJoinPaths('a/', 'b'), 'a/b');
      expect(naJoinPaths('a', '/b'), 'a/b');
      expect(naJoinPaths('', 'b'), 'b');
      expect(naJoinPaths('a', ''), 'a');
      expect(naJoinPaths(null, 'b'), 'b');
    });

    test('StringPath addQueryParam should append query params', () {
      final String path = 'https://example.com/api';
      final updatedPath = StringPathExtensions(path).addQueryParamString('test', '123');
      expect(updatedPath, 'https://example.com/api?test=123');
    });

    test('NaRoutesConfiguration should generate proper paths', () {
      final parentConfig = NaRoutesConfiguration(null, [NaRoutesPath.fix('home')]);
      final childConfig = NaRoutesConfiguration(parentConfig, [
        NaRoutesPath.fix('details'),
        NaRoutesPath('id', replaceWith: '123')
      ]);

      expect(parentConfig.fullPath, 'home');
      expect(childConfig.relativePath, 'details/123');
      expect(childConfig.fullPath, 'home/details/123');
      expect(childConfig.routePath, 'details/id');
    });
  });
}
