import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  final _storage = const FlutterSecureStorage();

  Future<void> saveSession(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getSession(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteSession(String key) async {
    await _storage.delete(key: key);
  }
}