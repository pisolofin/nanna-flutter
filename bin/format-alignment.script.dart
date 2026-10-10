import 'dart:io';

void main(List<String> args) {
  final bool isVerbose = args.contains('--verbose') || args.contains('-v');
  final List<String> positionalArgs = args.where((argument) => !argument.startsWith('-')).toList();
  final String targetPath = positionalArgs.isNotEmpty ? positionalArgs.first : 'lib';
  final List<File> files;

  if (FileSystemEntity.isFileSync(targetPath)) {
    files = [File(targetPath)];
  } else if (FileSystemEntity.isDirectorySync(targetPath)) {
    final dir = Directory(targetPath);
    files = dir.listSync(recursive: true).whereType<File>().where((fileEntity) => fileEntity.path.endsWith('.dart')).toList();
  } else {
    print('Path $targetPath does not exist.');
    return;
  }

  final alignRegex = RegExp(r'^(\s+)([a-zA-Z0-9_]+)\s*:(.*)$');
  final ternaryRegex = RegExp(r'^([ \t]*)final\s+([A-Za-z0-9_]+)\?\s+([A-Za-z0-9_]+)\s*=\s*\n?\s*options\s+is\s+\2\s*\?\s*options\s*:\s*null\s*;', multiLine: true);
  final bracesRegex = RegExp(r'(?<!\$)\{[ \t]*([^\n{}]+?)[ \t]*\}');
  final braceKeywordsRegex = RegExp(r'\}\s+(else|catch|finally)\b');

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

    final newContent3 = content.replaceAllMapped(braceKeywordsRegex, (match) {
      final keyword = match.group(1)!;
      return '}$keyword';
    });

    if (newContent3 != content) {
      content = newContent3;
    }

    final formattedIfLines = _formatIfStatements(content.split('\n'));
    content = formattedIfLines.join('\n').replaceAllMapped(braceKeywordsRegex, (match) {
      final keyword = match.group(1)!;
      return '}$keyword';
    });

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
          final trimmedRest = rest.trimLeft();
          final formattedRest = trimmedRest.isNotEmpty ? ' $trimmedRest' : '';
          final newLine = '$indent$paramName$padding:$formattedRest';
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
  print('✅ Allineamento verticale e tabulazione completati per: $targetPath');
}

int? _findMatchingParen(String s, int startIndex) {
  int depth = 0;
  bool inSingleQuote = false;
  bool inDoubleQuote = false;

  for (int i = startIndex; i < s.length; i++) {
    final char = s[i];
    final prevChar = i > startIndex ? s[i - 1] : '';

    if (inSingleQuote) {
      if (char == "'" && prevChar != '\\') {
        inSingleQuote = false;
      }
      continue;
    }
    if (inDoubleQuote) {
      if (char == '"' && prevChar != '\\') {
        inDoubleQuote = false;
      }
      continue;
    }

    if (char == '/' && i + 1 < s.length && s[i + 1] == '/') {
      break;
    }

    if (char == "'") {
      inSingleQuote = true;
    }else if (char == '"') {
      inDoubleQuote = true;
    }else if (char == '(') {
      depth++;
    }else if (char == ')') {
      depth--;
      if (depth == 0) {
        return i;
      }
    }
  }
  return null;
}

List<String> _formatIfStatements(List<String> lines) {
  final ifRegex = RegExp(r'^(\s*)((?:\}else\s+|else\s+)?if)\s*\(');
  final elseRegex = RegExp(r'^(\s*)((?:\}else|else))\s+(.+)$');
  final result = <String>[];

  int i = 0;
  while (i < lines.length) {
    final line = lines[i];
    final match = ifRegex.firstMatch(line);

    if (match != null) {
      final indent = match.group(1)!;
      final openParenIndex = match.end - 1; // index of '('

      int conditionEndLine = i;
      int? closeParenIndex = _findMatchingParen(lines[i], openParenIndex);
      String fullHeader = lines[i];

      while (closeParenIndex == null && conditionEndLine + 1 < lines.length) {
        conditionEndLine++;
        fullHeader += '\n${lines[conditionEndLine]}';
        closeParenIndex = _findMatchingParen(fullHeader, openParenIndex);
      }

      if (closeParenIndex != null) {
        final afterParen = fullHeader.substring(closeParenIndex + 1).trim();

        // If afterParen is '{', it already opens a block
        if (afterParen == '{') {
          for (int k = i; k <= conditionEndLine; k++) {
            result.add(lines[k]);
          }
          i = conditionEndLine + 1;
          continue;
        }

        // If afterParen starts with '{' and contains '}' (single-line block)
        if (afterParen.startsWith('{') && afterParen.contains('}')) {
          final headerPart = fullHeader.substring(0, closeParenIndex + 1);
          final firstBrace = afterParen.indexOf('{');
          final lastBrace = afterParen.lastIndexOf('}');
          final inner = afterParen.substring(firstBrace + 1, lastBrace).trim();
          final trailing = afterParen.substring(lastBrace + 1).trim();

          if (inner.isNotEmpty) {
            result.add('$headerPart {');
            result.add('$indent  $inner${trailing.isNotEmpty ? ' $trailing' : ''}');
            result.add('$indent}');
            i = conditionEndLine + 1;
            continue;
          }
        }

        // If afterParen is a statement (ends with ';' or has comment)
        if (afterParen.isNotEmpty && !afterParen.startsWith('{')) {
          final withoutComment = afterParen.split('//').first.trim();
          if (withoutComment.endsWith(';')) {
            final headerPart = fullHeader.substring(0, closeParenIndex + 1);
            result.add('$headerPart {');
            result.add('$indent  $afterParen');
            result.add('$indent}');
            i = conditionEndLine + 1;
            continue;
          }
        }

        // If afterParen is empty, check if next line is a single statement without braces
        if (afterParen.isEmpty && conditionEndLine + 1 < lines.length) {
          final nextLine = lines[conditionEndLine + 1];
          final nextTrimmed = nextLine.trim();
          final nextWithoutComment = nextTrimmed.split('//').first.trim();

          if (nextTrimmed.isNotEmpty &&
              !nextTrimmed.startsWith('{') &&
              !nextTrimmed.startsWith('//') &&
              nextWithoutComment.endsWith(';')) {
            for (int k = i; k < conditionEndLine; k++) {
              result.add(lines[k]);
            }
            result.add('${lines[conditionEndLine]} {');
            result.add('$indent  $nextTrimmed');
            result.add('$indent}');
            i = conditionEndLine + 2;
            continue;
          }
        }
      }
    }

    // Check else without if: e.g. '}else return null;' or 'else return null;'
    final elseMatch = elseRegex.firstMatch(line);
    if (elseMatch != null && !elseMatch.group(3)!.trim().startsWith('if')) {
      final indent = elseMatch.group(1)!;
      final elseKeyword = elseMatch.group(2)!.trim();
      final afterElse = elseMatch.group(3)!.trim();

      if (afterElse.startsWith('{') && afterElse.contains('}')) {
        final firstBrace = afterElse.indexOf('{');
        final lastBrace = afterElse.lastIndexOf('}');
        final inner = afterElse.substring(firstBrace + 1, lastBrace).trim();
        final trailing = afterElse.substring(lastBrace + 1).trim();

        if (inner.isNotEmpty) {
          result.add('$indent$elseKeyword {');
          result.add('$indent  $inner${trailing.isNotEmpty ? ' $trailing' : ''}');
          result.add('$indent}');
          i++;
          continue;
        }
      }else if (!afterElse.startsWith('{')) {
        final withoutComment = afterElse.split('//').first.trim();
        if (withoutComment.endsWith(';')) {
          result.add('$indent$elseKeyword {');
          result.add('$indent  $afterElse');
          result.add('$indent}');
          i++;
          continue;
        }
      }
    }

    result.add(line);
    i++;
  }

  return result;
}

