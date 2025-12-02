import 'package:shared_preferences/shared_preferences.dart';

class JwtKey {
  // Singleton
  static final JwtKey _instance = JwtKey._internal();
  factory JwtKey() => _instance;
  JwtKey._internal();

  String? _token;
  static const String _storageKey = 'jwt_token';

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_storageKey);
  }

  Future<void> setJwtKey(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, token);
  }

  Future<String?> getJwtKey() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_storageKey);
    return _token;
  }

  bool hasKey() => _token != null;

  Future<void> clear() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
