import 'package:dynadoc_front/models/user.dart';

import 'http_request.dart';
import 'jwt_key.dart';

class UserRequests extends HttpRequest {
  Future<bool> login(String email, String password) async {
    try {
      final body = {'email': email, 'password': password};
      // Uses the inherited sendPostRequest
      final response = await sendPostRequest('auth/login', body, auth: false);

      // Save token to Singleton
      if (response['token'] != null) {
        JwtKey().setJwtKeyAndRole(response['token'], response['role']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  Future<bool> register(User user, String password) async {
    try {
      final body = user.toJson();
      body['password'] = password; // Add password to the map

      await sendPostRequest('auth/register', body, auth: false);
      return true;
    } catch (e) {
      print('Register Error: $e');
      return false;
    }
  }
}
