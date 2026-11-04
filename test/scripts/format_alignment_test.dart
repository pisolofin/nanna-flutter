import 'package:flutter_test/flutter_test.dart';

import '../../bin/format-alignment.script.dart';

void main() {
  group('format-alignment script', () {
    test('aligns regex variable declarations with =', () {
      const input = '''
  final alignRegex = RegExp(r'^(\\s+)([a-zA-Z0-9_]+)\\s*:(.*)\$');
  final ternaryRegex = RegExp(r'^([ \\t]*)final\\s+([A-Za-z0-9_]+)\\?\\s+([A-Za-z0-9_]+)\\s*=\\s*\\n?\\s*options\\s+is\\s+\\2\\s*\\?\\s*options\\s*:\\s*null\\s*;', multiLine: true);
  final bracesRegex = RegExp(r'(?<!\\\$)\\{[ \\t]*([^\\n{}]+?)[ \\t]*\\}');
  final braceKeywordsRegex = RegExp(r'\\}\\s+(else|catch|finally|on)\\b');
''';

      const expected = '''
  final alignRegex         = RegExp(r'^(\\s+)([a-zA-Z0-9_]+)\\s*:(.*)\$');
  final ternaryRegex       = RegExp(r'^([ \\t]*)final\\s+([A-Za-z0-9_]+)\\?\\s+([A-Za-z0-9_]+)\\s*=\\s*\\n?\\s*options\\s+is\\s+\\2\\s*\\?\\s*options\\s*:\\s*null\\s*;', multiLine: true);
  final bracesRegex        = RegExp(r'(?<!\\\$)\\{[ \\t]*([^\\n{}]+?)[ \\t]*\\}');
  final braceKeywordsRegex = RegExp(r'\\}\\s+(else|catch|finally|on)\\b');
''';

      final output = formatAlignmentContent(input);
      expect(output, expected);
    });

    test('aligns named parameters with :', () {
      const input = '''
Widget build(BuildContext context) {
  return Container(
    width: 100,
    height: 200,
    color: Colors.red,
  );
}
''';

      const expected = '''
Widget build(BuildContext context) {
  return Container(
    width : 100,
    height: 200,
    color : Colors.red,
  );
}
''';

      final output = formatAlignmentContent(input);
      expect(output, expected);
    });

    test('formats ternary operator pattern', () {
      const input = '''
final MyType? myVar = options is MyType ? options : null;
''';

      const expected = '''
final MyType? myVar = options is MyType
  ? options
  : null
;
''';

      final output = formatAlignmentContent(input);
      expect(output, expected);
    });

    test('enforces no space between closing brace and else / catch', () {
      const input = '''
void test() {
  if (true) {
    print('yes');
  } else {
    print('no');
  }
}
''';

      const expected = '''
void test() {
  if (true) {
    print('yes');
  }else {
    print('no');
  }
}
''';

      final output = formatAlignmentContent(input);
      expect(output, expected);
    });

    test('is idempotent: running multiple times preserves the formatted output', () {
      const input = '''
  final alignRegex         = RegExp(r'^(\\s+)([a-zA-Z0-9_]+)\\s*:(.*)\$');
  final ternaryRegex       = RegExp(r'^([ \\t]*)final\\s+([A-Za-z0-9_]+)\\?\\s+([A-Za-z0-9_]+)\\s*=\\s*\\n?\\s*options\\s+is\\s+\\2\\s*\\?\\s*options\\s*:\\s*null\\s*;', multiLine: true);
  final bracesRegex        = RegExp(r'(?<!\\\$)\\{[ \\t]*([^\\n{}]+?)[ \\t]*\\}');
  final braceKeywordsRegex = RegExp(r'\\}\\s+(else|catch|finally|on)\\b');
''';

      final firstPass = formatAlignmentContent(input);
      final secondPass = formatAlignmentContent(firstPass);
      expect(secondPass, input);
    });
  });
}

