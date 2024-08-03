import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ReceiptService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = const FlutterSecureStorage();

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
    final responseBody = await http.Response.fromStream(response);
    final decodedResponse = jsonDecode(responseBody.body);

    if (response.statusCode == 200) {
      return decodedResponse;
    } else {
      throw Exception('Failed to upload image');
    }
  }
}
