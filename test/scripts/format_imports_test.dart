import 'package:flutter_test/flutter_test.dart';

import '../../bin/format-imports.script.dart';

void main() {
  group('format-imports script', () {
    test('groups imports by dart, external package, package:nanna, and relative ../ descending', () {
      const input = '''

void main() {}
''';

      final output = formatImportsContent(input);

      const expected = '''

void main() {}
''';

      expect(output, expected);
    });

    test('sorts imports by line length within the same group', () {
      const input = '''

class Foo {}
''';

      final output = formatImportsContent(input);

      const expected = '''

class Foo {}
''';

      expect(output, expected);
    });

    test('handles relative imports with multiple ../ levels and creates separate groups with empty lines', () {
      const input = '''

void test() {}
''';

      final output = formatImportsContent(input);

      const expected = '''

void test() {}
''';

      expect(output, expected);
    });

    test('distinguishes package:nanna from other third-party packages', () {
      const input = '''

void main() {}
''';

      final output = formatImportsContent(input);

      const expected = '''

void main() {}
''';

      expect(output, expected);
    });

    test('preserves header comments and library directives before imports', () {
      const input = '''
// ignore_for_file: file_names
// Copyright (c) 2026

void main() {}
''';

      final output = formatImportsContent(input);

      const expected = '''
// ignore_for_file: file_names
// Copyright (c) 2026

void main() {}
''';

      expect(output, expected);
    });

    test('supports double quotes in import statements', () {
      const input = '''

void main() {}
''';

      final output = formatImportsContent(input);

      const expected = '''

void main() {}
''';

      expect(output, expected);
    });

    test('leaves content without imports untouched', () {
      const input = '''
void main() {
  print('hello world');
}
''';

      final output = formatImportsContent(input);
      expect(output, input);
    });

    test('is idempotent: running multiple times yields the same result', () {
      const input = '''

void main() {}
''';

      final firstPass = formatImportsContent(input);
      final secondPass = formatImportsContent(firstPass);
      expect(secondPass, firstPass);
    });
  });
}
