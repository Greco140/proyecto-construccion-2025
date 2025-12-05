import 'dart:convert';
import 'package:http/http.dart' as http;
import 'jwt_key.dart';

abstract class HttpRequest {
  final String baseUrl = 'https://dynadocs.onrender.com/api/';

  Future<Map<String, String>> _getHeaders({bool isAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (isAuth) {
      final token = await JwtKey().getJwtKey();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    } else {
      headers['Authorization'] = 'Bearer none';
    }
    return headers;
  }

  Future<dynamic> sendGetRequest(String endpoint, {bool auth = true}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(isAuth: auth),
    );
    return _processResponse(response);
  }

  Future<dynamic> sendPostRequest(
    String endpoint,
    dynamic body, {
    bool auth = true,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(isAuth: auth),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Especifico para los PDF
  Future<List<int>> sendPostRequestBytes(
    String endpoint,
    dynamic body, {
    bool auth = true,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(isAuth: auth),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<dynamic> sendPutRequest(
    String endpoint,
    dynamic body, {
    bool auth = true,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(isAuth: auth),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  Future<dynamic> sendDeleteRequest(String endpoint, {bool auth = true}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(isAuth: auth),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error: ${response.statusCode}');
    }
    return true;
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return null;
      }
    } else {
      throw Exception(
        'Request failed: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
