import 'dart:io';

void main(List<String> args) {
  final bool isVerbose = args.contains('--verbose') || args.contains('-v');
  final List<String> positionalArgs = args.where((argument) => !argument.startsWith('-')).toList();
  final String targetDir = positionalArgs.isNotEmpty ? positionalArgs.first : 'lib';
  final Directory dir = Directory(targetDir);
  
  if (!dir.existsSync()) {
    print('Directory $targetDir does not exist.');
    return;
  }

  final files = dir.listSync(recursive: true).whereType<File>().where((fileEntity) => fileEntity.path.endsWith('.dart'));

  final alignRegex = RegExp(r'^(\s+)([a-zA-Z0-9_]+)\s*:(.*)$');
  final ternaryRegex = RegExp(r'^([ \t]*)final\s+([A-Za-z0-9_]+)\?\s+([A-Za-z0-9_]+)\s*=\s*\n?\s*options\s+is\s+\2\s*\?\s*options\s*:\s*null\s*;', multiLine: true);
  final bracesRegex = RegExp(r'(?<!\$)\{[ \t]*([^\n{}]+?)[ \t]*\}');

  for (final file in files) {
    if (isVerbose) {
      print('Analyzing: ${file.path}');
    }

    String content = file.readAsStringSync().replaceAll('\r\n', '\n');

    // Convert tabs to two spaces
    if (content.contains('\t')) {
      content = content.replaceAll('\t', '  ');
    }

    final newContent1 = content.replaceAllMapped(ternaryRegex, (match) {
      final indent = match.group(1)!;
      final type = match.group(2)!;
      final varName = match.group(3)!;
      return '${indent}final $type? $varName = options is $type\n$indent  ? options\n$indent  : null\n$indent;';
    });
    
    if (newContent1 != content) {
      content = newContent1;
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
        }
        lineIndex = scanIndex;
      }else {
        newLines.add(lines[lineIndex]);
        lineIndex++;
      }
    }
    
    // Ensure the file ends with one and only one empty line
    while (newLines.isNotEmpty && newLines.last.trim().isEmpty) {
      newLines.removeLast();
    }
    if (newLines.isNotEmpty) {
      newLines.add('');
    }

    final formattedContent = newLines.join('\r\n');
    if (formattedContent != file.readAsStringSync()) {
      file.writeAsStringSync(formattedContent);
    }
  }
  print('✅ Allineamento verticale e tabulazione completati per la cartella: $targetDir');
}
