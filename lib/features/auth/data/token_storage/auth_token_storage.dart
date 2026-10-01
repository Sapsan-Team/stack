import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthTokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();
}

final class SecureAuthTokenStorage implements AuthTokenStorage {
  SecureAuthTokenStorage({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences legacyPreferences,
  }) : _secureStorage = secureStorage,
       _legacyPreferences = legacyPreferences;

  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _legacyPreferences;

  @override
  Future<String?> read() async {
    final token = await _secureStorage.read(key: _tokenKey);
    if (token != null) {
      return token;
    }

    final legacyToken = _legacyPreferences.getString(_tokenKey);
    if (legacyToken == null || legacyToken.isEmpty) {
      return null;
    }

    await write(legacyToken);
    return legacyToken;
  }

  @override
  Future<void> write(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
    await _legacyPreferences.remove(_tokenKey);
  }

  @override
  Future<void> delete() async {
    await _secureStorage.delete(key: _tokenKey);
    await _legacyPreferences.remove(_tokenKey);
  }
}
