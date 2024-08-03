import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/expense_model.dart';

class ExpenseService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = const FlutterSecureStorage();

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
      return [];
    }
  }

  Future<List<Expense>> fetchAllExpenses() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/expense'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data']['expenses'];
      return data.map((json) => Expense.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load receipts');
    }
  }

  Future<Expense> createExpense(String tripId, Map<String, dynamic> expenseData) async {
    print(tripId);
    print(expenseData);
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/expense/$tripId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(expenseData),
    );
    print(response.statusCode);
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final Map<String, dynamic> data = responseData['data']['expense'];
      return Expense.fromJson(data);
    } else {
      print('Failed to create expense: ${response.body}');
      throw Exception('Failed to create expense');
    }
  }

  Future<Expense> updateExpense(String expenseId, Map<String, dynamic> updates) async {
    final token = await getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/api/v1/expense/$expenseId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return Expense.fromJson(data);
    } else {
      throw Exception('Failed to update expense in service');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/expense/$expenseId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete expense');
    }
  }
}
