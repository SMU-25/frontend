import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageKey {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
}

class SecureStorageService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: SecureStorageKey.accessToken, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: SecureStorageKey.accessToken);
  }

  static Future<void> deleteAccessToken() async {
    await _storage.delete(key: SecureStorageKey.accessToken);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: SecureStorageKey.refreshToken, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: SecureStorageKey.refreshToken);
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: SecureStorageKey.refreshToken);
  }
}
