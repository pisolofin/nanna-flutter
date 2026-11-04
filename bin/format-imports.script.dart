import 'dart:io';

/// Formats Dart import statements in [content] according to the following rules:
/// 1. `import 'dart:...`
/// 2. `import 'package:...` (third-party packages)
/// 3. `import 'package:nanna...`
/// 4. Relative imports (`import '...`): grouped by the count of `../` in descending order
///    (imports with more `../` first, down to 0 `../`), with an empty line between each group.
///
/// Within each group, imports are sorted by line length (shortest to longest),
/// and alphabetically if lengths are equal.
String formatImportsContent(String content) {
  final lineEnding = content.contains('\r\n') ? '\r\n' : '\n';
  final lines = content.split(RegExp(r'\r?\n'));

  final dartImports = <String>[];
  final packageImports = <String>[];
  final nannaImports = <String>[];
  final Map<int, List<String>> relativeImportsByLevel = {};

  int importStartIndex = -1;
  int importEndIndex = -1;
  bool hasImports = false;

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.startsWith('import ') && line.endsWith(';')) {
      if (importStartIndex == -1) {
        importStartIndex = i;
      }
      hasImports = true;
      importEndIndex = i;

      final match = RegExp(r'''import\s+['"]([^'"]+)['"]''').firstMatch(line);
      final uri = match?.group(1) ?? '';

      if (uri.startsWith('dart:')) {
        dartImports.add(line);
      } else if (uri == 'package:nanna' || uri.startsWith('package:nanna/')) {
        nannaImports.add(line);
      } else if (uri.startsWith('package:')) {
        packageImports.add(line);
      } else {
        final parentCount = RegExp(r'\.\.[/\\]').allMatches(uri).length;
        relativeImportsByLevel.putIfAbsent(parentCount, () => <String>[]).add(line);
      }
    } else if (line.isNotEmpty &&
        !line.startsWith('//') &&
        !line.startsWith('/*') &&
        !line.startsWith('*') &&
        !line.startsWith('library ') &&
        hasImports) {
      break;
    }
  }

  if (!hasImports) {
    return content;
  }

  int compareImports(String a, String b) {
    final lengthComparison = a.length.compareTo(b.length);
    if (lengthComparison != 0) return lengthComparison;
    return a.compareTo(b);
  }

  dartImports.sort(compareImports);
  packageImports.sort(compareImports);
  nannaImports.sort(compareImports);

  final sortedLevels = relativeImportsByLevel.keys.toList()..sort((a, b) => b.compareTo(a));
  for (final level in sortedLevels) {
    relativeImportsByLevel[level]!.sort(compareImports);
  }

  final groups = <List<String>>[];
  if (dartImports.isNotEmpty) {
    groups.add(dartImports);
  }
  if (packageImports.isNotEmpty) {
    groups.add(packageImports);
  }
  if (nannaImports.isNotEmpty) {
    groups.add(nannaImports);
  }
  for (final level in sortedLevels) {
    final group = relativeImportsByLevel[level]!;
    if (group.isNotEmpty) {
      groups.add(group);
    }
  }

  final formattedImportLines = <String>[];
  for (int i = 0; i < groups.length; i++) {
    formattedImportLines.addAll(groups[i]);
    if (i < groups.length - 1) {
      formattedImportLines.add('');
    }
  }

  final newLines = <String>[];
  bool addedImports = false;

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trim();

    if (i >= importStartIndex && (trimmed.startsWith('import ') || (trimmed.isEmpty && i <= importEndIndex))) {
      if (!addedImports) {
        newLines.addAll(formattedImportLines);
        newLines.add('');
        addedImports = true;
      }
    } else {
      newLines.add(line);
    }
  }

  final cleanedLines = <String>[];
  for (int i = 0; i < newLines.length; i++) {
    if (newLines[i].trim().isEmpty) {
      if (cleanedLines.isEmpty || cleanedLines.last.trim().isNotEmpty) {
        cleanedLines.add('');
      }
    } else {
      cleanedLines.add(newLines[i]);
    }
  }

  return cleanedLines.join(lineEnding);
}

void main(List<String> args) {
  final bool isVerbose = args.contains('--verbose') || args.contains('-v');
  final List<String> positionalArgs = args.where((argument) => !argument.startsWith('-')).toList();
  final String targetPath = positionalArgs.isNotEmpty ? positionalArgs.first : 'lib';
  final List<File> files;

  if (FileSystemEntity.isFileSync(targetPath)) {
    files = [File(targetPath)];
  } else if (FileSystemEntity.isDirectorySync(targetPath)) {
    final dir = Directory(targetPath);
    files = dir
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .where((fileEntity) => fileEntity.path.endsWith('.dart'))
        .where((fileEntity) {
          final norm = fileEntity.path.replaceAll(r'\', '/');
          return !norm.contains('.plugin_symlinks') &&
              !norm.contains('.dart_tool') &&
              !norm.contains('/ephemeral/') &&
              !norm.contains('/build/');
        })
        .toList();
  } else {
    print('Path $targetPath does not exist.');
    return;
  }

  for (final file in files) {
    if (isVerbose) {
      print('Analyzing: ${file.path}');
    }

    final content = file.readAsStringSync();
    final formatted = formatImportsContent(content);

    if (formatted != content) {
      file.writeAsStringSync(formatted);
    }
  }

  print('✅ Ordinamento degli import (per lunghezza) completato per: $targetPath');
}
