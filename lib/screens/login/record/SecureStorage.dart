import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Private constructor
  SecureStorage._();

  // Singleton instance
  static final SecureStorage _instance = SecureStorage._();

  // Factory method to provide the instance
  factory SecureStorage() => _instance;

  // FlutterSecureStorage instance
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Methods to interact with secure storage

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String> readSecureData(String key) async {
    return await _storage.read(key: key) ?? 'No data found';
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }
}