import 'package:shared_preferences/shared_preferences.dart';

class JwtKey {
  // Singleton
  static final JwtKey _instance = JwtKey._internal();
  factory JwtKey() => _instance;
  JwtKey._internal();

  String? _token;
  static const String _storageKey = 'jwt_token';
  static const String _roleKey = 'user_role';

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_storageKey);
  }

  Future<void> setJwtKeyAndRole(String token, String role) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, token);
    await prefs.setString(_roleKey, role);
  }

  Future<String?> getJwtKey() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_storageKey);
    return _token;
  }

  Future<bool> hasJwtKey() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_storageKey);
    return token != null;
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  bool hasKey() => _token != null;

  Future<void> clear() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
