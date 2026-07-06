import 'package:nanna_flutter/nanna_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

late final FlutterSecureStorage _secureStorage;

/// Initialize Secure storage
void naSecureStorageInit() {
  AndroidOptions getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  _secureStorage = FlutterSecureStorage(
    aOptions: getAndroidOptions()
  );
}

/// Decrypts and returns the value for the given [key] or null if [key] is not in the storage.
Future<String?> naSecureStorageReadAsync(String key) {
  return _secureStorage.read(key: key);
}

/// Encrypts and saves the [key] with the given [value].
Future naSecureStorageWriteAsync(String key, String value) {
  return _secureStorage.write(key: key, value: value);
}

/// Deletes associated value for the given [key].
Future naSecureStorageDeleteAsync(String key) {
  return _secureStorage.delete(key: key);
}

/// Deletes all keys with associated values.
Future naSecureStorageDeleteAllAsync() {
  return _secureStorage.deleteAll();
}

/// Decrypts and returns the value for the given [key] or null if [key] is not in the storage.
Future<bool?> naSecureStorageReadBoolAsync(String key) async {
  String? valueString = await _secureStorage.read(key: key);
  return valueString == '1';
}

/// Encrypts and saves the [key] with the given [value].
Future naSecureStorageWriteBoolAsync(String key, bool value) {
  return naSecureStorageWriteAsync(key, value ? '1' : '0');
}

/// Decrypts and returns the value for the given [key] or null if [key] is not in the storage.
Future<DateTime?> naSecureStorageReadDateOnlyAsync(String key) async {
  String? valueString = await naSecureStorageReadAsync(key);
  if (valueString == null) {
    return null;
  }
  return DateTime.parse(valueString);
}

/// Encrypts and saves the [key] with the given [value].
Future naSecureStorageWriteDateOnlyAsync(String key, DateTime value) {
  String valueString = value.toIso8601DateOnlyString();
  return naSecureStorageWriteAsync(key, valueString);
}
