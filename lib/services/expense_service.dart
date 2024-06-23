import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/expense_model.dart';

class ExpenseService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<List<Expense>> fetchExpenses(String tripId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/expense/$tripId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data']['expenses'];
      return Expense.fromJsonList(data);
    } else {
      print('Response status code: ${response.statusCode}');
      print('token is: ${token}');
      return [];
    }
  }
}
