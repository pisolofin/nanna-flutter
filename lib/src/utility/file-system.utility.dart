import 'dart:io';
import 'dart:convert';

/// Saves a JSON object to a file. If the file already exists, it will be overwritten.
Future jsonToFileAsync<T>(T jsonObject, File file) async {
  final String jsonString = jsonEncode(jsonObject);
  await file.writeAsString(
    jsonString,
    mode: FileMode.write
  );
}

/// Reads a JSON object from the specified file and parses it with [converter].
Future<T?> jsonFromFileAsync<T>(File file, T Function(Map<String, dynamic> jsonMap) converter) async {
  // iIf file doesn't exist, null
  if (!await file.exists()) {
    return null;
  }

  final String jsonString = await file.readAsString();
  // If string is null or empty, null
  if (jsonString.isEmpty) {
    return null;
  }

  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  return converter(jsonMap);
}
