import 'dart:io';

void main(List<String> args) {
  final targetDir = args.isNotEmpty ? args.first : 'lib';
  final dir = Directory(targetDir);
  
  if (!dir.existsSync()) {
    print('Directory $targetDir does not exist.');
    return;
  }

  final files = dir.listSync(recursive: true).whereType<File>().where((fileEntity) => fileEntity.path.endsWith('.dart'));

  final alignRegex = RegExp(r'^(\s+)([a-zA-Z0-9_]+)\s*:(.*)$');
  final ternaryRegex = RegExp(r'^([ \t]*)final\s+([A-Za-z0-9_]+)\?\s+([A-Za-z0-9_]+)\s*=\s*\n?\s*options\s+is\s+\2\s*\?\s*options\s*:\s*null\s*;', multiLine: true);
  final bracesRegex = RegExp(r'(?<!\$)\{[ \t]*([^\n{}]+?)[ \t]*\}');

  for (final file in files) {
    String content = file.readAsStringSync().replaceAll('\r\n', '\n');

    bool changed = false;

    // Convert tabs to two spaces
    if (content.contains('\t')) {
      content = content.replaceAll('\t', '  ');
      changed = true;
    }

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
    
    int lineIndex = 0;
    while (lineIndex < lines.length) {
      final match = alignRegex.firstMatch(lines[lineIndex]);
      if (match != null) {
        final indent = match.group(1)!;
        int scanIndex = lineIndex;
        int maxColonIndex = 0;
        
        while (scanIndex < lines.length) {
          final currentMatch = alignRegex.firstMatch(lines[scanIndex]);
          if (currentMatch != null && currentMatch.group(1) == indent) {
            final paramName = currentMatch.group(2)!;
            final colonIndex = indent.length + paramName.length;
            if (colonIndex > maxColonIndex) {
              maxColonIndex = colonIndex;
            }
            scanIndex++;
          }else {
            break;
          }
        }
        
        for (int applyIndex = lineIndex; applyIndex < scanIndex; applyIndex++) {
          final currentMatch = alignRegex.firstMatch(lines[applyIndex])!;
          final paramName = currentMatch.group(2)!;
          final rest = currentMatch.group(3)!;
          final padding = ' ' * (maxColonIndex - (indent.length + paramName.length));
          final newLine = '$indent$paramName$padding:$rest';
          newLines.add(newLine);
          if (newLine != lines[applyIndex]) {
            changed = true;
          }
        }
        lineIndex = scanIndex;
      }else {
        newLines.add(lines[lineIndex]);
        lineIndex++;
      }
    }
    
    if (changed) {
      file.writeAsStringSync(newLines.join('\r\n'));
    }
  }
  print('✅ Allineamento verticale e tabulazione completati per la cartella: $targetDir');
}
