import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<User?> fetchUserProfile() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/user/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> updateUserProfile(Profile profile) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'profile': profile}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/user/notification-settings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'notificationSettings': settings}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update notification settings');
    }
  }
}