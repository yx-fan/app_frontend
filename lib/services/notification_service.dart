import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/notification_model.dart';

class NotificationService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<List<Notification>> fetchNotifications() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/notification/notifications'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body)['data']['notifications'];
      return body.map((dynamic item) => Notification.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}
