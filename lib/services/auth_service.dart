import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  Future<bool> sendVerificationEmail(String email) async {
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

    return response.statusCode == 200;
  }

  Future<bool> register(String email, String password) async {
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

    return response.statusCode == 200;
  }
}
