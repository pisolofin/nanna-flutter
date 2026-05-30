/// Converts a dynamic input to a Map<String, dynamic>.
Map<String, dynamic> convertToMap(dynamic input) {
  if (input is Map<String, dynamic>) {
    return input;
  }

  Map<String, dynamic> convertedMap = {};
  // Map<Object?, Object?>
  if (input is Map<Object?, Object?>) {
    for (MapEntry<Object?, Object?> entry in input.entries) {
      if (entry.key == null) {
        continue;
      }
      convertedMap[entry.key.toString()] = entry.value;
    }
  }
  return convertedMap;
}
