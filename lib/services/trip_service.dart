import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/trip_model.dart';

class TripService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<List<Trip>> fetchTrips() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/trip'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return Trip.fromJsonList(data);
    } else {
      print('Response status code: ${response.statusCode}');
      print('token is: ${token}');
      return [];
    }
  }

  Future<bool> createTrip(String tripName, DateTime startDate, DateTime endDate,
      String description) async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/trip'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'tripName': tripName,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Create trip error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Create trip exception: $e');
      return false;
    }
  }
}
