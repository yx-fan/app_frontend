import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<Map<String, String>> fetchAllCurrencies() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/currency'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data =
          jsonDecode(response.body)['data']['currencies'];
      return Map<String, String>.fromIterable(
        data,
        key: (item) => item['_id'] as String,
        value: (item) => item['code'] as String,
      );
    } else {
      print('Response status code: ${response.statusCode}');
      return {};
    }
  }
}
