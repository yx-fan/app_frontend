import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = FlutterSecureStorage();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthService() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoggedIn = await checkTokenExists();
    notifyListeners();
  }

  // Send verification email
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

  // Register user
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

      if (response.statusCode == 200) {
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

  // User login
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

  // User logout
  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _isLoggedIn = false;
    notifyListeners();
  }
}
