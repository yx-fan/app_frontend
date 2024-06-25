import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constant.dart';

class GooglePlacesService {
  final String apiKey = GOOGLE_MAPS_API_KEY;

  Future<List<LatLng>> searchPlaces(String query) async {
    final url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        final results = json['results'] as List;
        return results.map((result) {
          final location = result['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }).toList();
      } else {
        throw Exception('Failed to load places');
      }
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<List<String>> autocompletePlaces(String query) async {
    final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        final predictions = json['predictions'] as List;
        return predictions.map((prediction) => prediction['description'] as String).toList();
      } else {
        throw Exception('Failed to load autocomplete suggestions');
      }
    } else {
      throw Exception('Failed to load autocomplete suggestions');
    }
  }
}
