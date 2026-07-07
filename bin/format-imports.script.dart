import 'dart:io';

void main(List<String> args) {
  final targetDir = args.isNotEmpty ? args.first : 'lib';
  final dir = Directory(targetDir);
  
  if (!dir.existsSync()) {
    print('Directory $targetDir does not exist.');
    return;
  }

  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    final lines = file.readAsLinesSync();
    final newLines = <String>[];
    
    final dartImports = <String>[];
    final packageImports = <String>[];
    final localImports = <String>[];
    
    int importEndIndex = -1;
    bool hasImports = false;

    // Raccoglie tutti gli import
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('import ') && line.endsWith(';')) {
        hasImports = true;
        importEndIndex = i;
        if (line.contains("'dart:")) {
          dartImports.add(lines[i]);
        } else if (line.contains("'package:")) {
          packageImports.add(lines[i]);
        } else {
          localImports.add(lines[i]);
        }
      } else if (line.isNotEmpty && !line.startsWith('//') && !line.startsWith('library ') && hasImports) {
        break; // Trovato il codice vero e proprio, si ferma
      }
    }

    if (!hasImports) continue; // Nessun import da formattare

    // Ordinamento per lunghezza della riga
    dartImports.sort((a, b) => a.length.compareTo(b.length));
    packageImports.sort((a, b) => a.length.compareTo(b.length));
    localImports.sort((a, b) => a.length.compareTo(b.length));

    // Ricostruisce il file
    bool addedImports = false;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      
      if (trimmed.startsWith('import ') || (trimmed.isEmpty && i <= importEndIndex)) {
        if (!addedImports) {
          if (dartImports.isNotEmpty) {
            newLines.addAll(dartImports);
            newLines.add('');
          }
          if (packageImports.isNotEmpty) {
            newLines.addAll(packageImports);
            newLines.add('');
          }
          if (localImports.isNotEmpty) {
            newLines.addAll(localImports);
            newLines.add('');
          }
          addedImports = true;
        }
      } else {
        newLines.add(line);
      }
    }
    
    // Rimuove eventuali doppie righe vuote prima del codice
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

    // Se c'è stata una modifica, salva
    if (cleanedLines.join('\n') != lines.join('\n')) {
      file.writeAsStringSync(cleanedLines.join('\r\n'));
    }
  }
  
  print('✅ Ordinamento degli import (per lunghezza) completato per la cartella: $targetDir');
}
