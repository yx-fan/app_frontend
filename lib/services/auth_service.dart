import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = const FlutterSecureStorage();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthService() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoggedIn = await checkTokenExists();
    if (_isLoggedIn) {
      _isLoggedIn = await _isTokenValid();
    }
    notifyListeners();
  }

  Future<bool> _isTokenValid() async {
    try {
      String? token = await _storage.read(key: 'token');
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/auth/validate-token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        await _storage.delete(key: 'token'); // delete Invalid token
        return false;
      }
    } catch (e) {
      print('isTokenValid exception: $e');
      return false;
    }
  }

  Future<bool> sendVerificationEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/send-verification-email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'type': 'register',
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('sendVerificationEmail error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('sendVerificationEmail exception: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        String token = jsonDecode(response.body)['data']['token'];
        await _storage.write(key: 'token', value: token);
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        print('register error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('register exception: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        String token = jsonDecode(response.body)['data']['token'];
        await _storage.write(key: 'token', value: token);
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        print('login error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('login exception: $e');
      return false;
    }
  }

  Future<bool> checkTokenExists() async {
    try {
      String? token = await _storage.read(key: 'token');
      return token != null;
    } catch (e) {
      print('checkTokenExists exception: $e');
      return false;
    }
  }

  Future<bool> checkEmailVerification(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/auth/check-email-verification?email=$email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('checkEmailVerification error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('checkEmailVerification exception: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _isLoggedIn = false;
    notifyListeners();
  }
}
