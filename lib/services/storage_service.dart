import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
  static const _apiKeyKey = 'api_key';
  static const _providerKey = 'provider';
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveApiKey(String apiKey, String provider) async {
    await _storage.write(key: _apiKeyKey, value: apiKey);
    await _prefs.setString(_providerKey, provider);
  }

  static Future<String?> getApiKey() async {
    return await _storage.read(key: _apiKeyKey);
  }

  static Future<String?> getProvider() async {
    return _prefs.getString(_providerKey);
  }

  static Future<bool> hasApiKey() async {
    final apiKey = await getApiKey();
    return apiKey != null;
  }

  static Future<void> clearApiKey() async {
    await _storage.delete(key: _apiKeyKey);
    await _prefs.remove(_providerKey);
  }
}