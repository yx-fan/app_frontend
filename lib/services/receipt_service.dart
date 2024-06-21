import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/map_model.dart';

class ReceiptService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  final _storage = FlutterSecureStorage();
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<List<Receipt>> fetchReceipts() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/expense'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data']['expenses'];
      return data.map((json) => Receipt.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load receipts');
    }
  }
}
