import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/map_model.dart';

class ReceiptService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<Map<String, dynamic>> uploadReceiptImage(File imageFile) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/v1/receipt/ocr');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('receipt', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await http.Response.fromStream(response);
      return jsonDecode(responseBody.body);
    } else {
      print('Failed to upload image');
      throw Exception('Failed to upload image');
    }
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
