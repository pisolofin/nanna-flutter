import 'dart:io';

void main(List<String> args) {
  final targetDir = args.isNotEmpty ? args.first : 'lib';
  final dir = Directory(targetDir);
  
  if (!dir.existsSync()) {
    print('Directory $targetDir does not exist.');
    return;
  }

  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final alignRegex = RegExp(r'^(\s+)([a-zA-Z0-9_]+)\s*:(.*)$');
  final ternaryRegex = RegExp(r'^([ \t]*)final\s+([A-Za-z0-9_]+)\?\s+([A-Za-z0-9_]+)\s*=\s*\n?\s*options\s+is\s+\2\s*\?\s*options\s*:\s*null\s*;', multiLine: true);
  final bracesRegex = RegExp(r'(?<!\$)\{[ \t]*([^\n{}]+?)[ \t]*\}');

  for (final file in files) {
    String content = file.readAsStringSync().replaceAll('\r\n', '\n');

    bool changed = false;

    final newContent1 = content.replaceAllMapped(ternaryRegex, (match) {
      final indent = match.group(1)!;
      final type = match.group(2)!;
      final varName = match.group(3)!;
      return '${indent}final $type? $varName = options is $type\n$indent  ? options\n$indent  : null\n$indent;';
    });
    
    if (newContent1 != content) {
      content = newContent1;
      changed = true;
    }

    final newContent2 = content.replaceAllMapped(bracesRegex, (match) {
      final inner = match.group(1)!;
      // Skip if it contains statements typical of blocks (like return, ;)
      if (inner.contains(';') || inner.contains('return ')) {
        return match.group(0)!;
      }
      return '{ $inner }';
    });
    
    if (newContent2 != content) {
      content = newContent2;
      changed = true;
    }

    final lines = content.split('\n');
    final newLines = <String>[];
    
    int i = 0;
    while (i < lines.length) {
      final match = alignRegex.firstMatch(lines[i]);
      if (match != null) {
        final indent = match.group(1)!;
        int j = i;
        int maxColonIndex = 0;
        
        while (j < lines.length) {
          final m = alignRegex.firstMatch(lines[j]);
          if (m != null && m.group(1) == indent) {
            final paramName = m.group(2)!;
            final colonIndex = indent.length + paramName.length;
            if (colonIndex > maxColonIndex) {
              maxColonIndex = colonIndex;
            }
            j++;
          } else {
            break;
          }
        }
        
        for (int k = i; k < j; k++) {
          final m = alignRegex.firstMatch(lines[k])!;
          final paramName = m.group(2)!;
          final rest = m.group(3)!;
          final padding = ' ' * (maxColonIndex - (indent.length + paramName.length));
          final newLine = '$indent$paramName$padding:$rest';
          newLines.add(newLine);
          if (newLine != lines[k]) {
            changed = true;
          }
        }
        i = j;
      } else {
        newLines.add(lines[i]);
        i++;
      }
    }
    
    if (changed) {
      file.writeAsStringSync(newLines.join('\r\n'));
    }
  }
  print('✅ Allineamento verticale completato per la cartella: $targetDir');
}
