import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/trip_model.dart';

class TripService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final _storage = const FlutterSecureStorage();

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
      print('token is: $token');
      return [];
    }
  }

  Future<bool> createTrip(String tripName, DateTime startDate, DateTime endDate,
      String description, String selectedCurrency, String imageUrl) async {
    try {
      print("image url from createTrip is:$imageUrl");
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
          'currencyCode': selectedCurrency,
          'image': imageUrl
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

  Future<bool> deleteTrip(String tripId) async {
    try {
      final token = await getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/v1/trip/$tripId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Delete trip error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Delete trip exception: $e');
      return false;
    }
  }

  Future<bool> revertTrip(String tripId) async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/trip/revert-deleted-trip/$tripId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      print("trip to be reverted is $tripId");

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Revert trip error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Revert trip exception: $e');
      return false;
    }
  }

  Future<Trip?> getOneTrip(String tripId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/trip/$tripId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Trip.fromJson(data); // Assuming data is a single trip object
    } else {
      print(
          'Response status code to get one trip with id $tripId is: ${response.statusCode}');
      print('Token is: $token');
      return null;
    }
  }

  Future<bool> editTrip(
      String tripID,
      String tripName,
      DateTime startDate,
      DateTime endDate,
      String description,
      String selectedCurrency,
      String imageUrl) async {
    try {
      print("image url from editTrip is:$imageUrl");
      final token = await getToken();
      final response = await http.patch(
        Uri.parse('$baseUrl/api/v1/trip/$tripID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'tripName': tripName,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'description': description,
          'currencyCode': selectedCurrency,
          'image': imageUrl
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Edit trip error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Edit trip exception: $e');
      return false;
    }
  }
}
