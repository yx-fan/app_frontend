import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/expense_service.dart';
import '../services/google_places_service.dart';
import '../models/expense_model.dart';

class MapViewModel extends ChangeNotifier {
  Expense? _selectedExpense;
  LatLng? _currentLocation;
  GoogleMapController? _mapController;
  TextEditingController searchController = TextEditingController();

  final ExpenseService expenseService = ExpenseService();
  final GooglePlacesService placesService = GooglePlacesService();

  void selectExpense(Expense expense) {
    _selectedExpense = expense;
    notifyListeners();
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(_selectedExpense!.latitude, _selectedExpense!.longitude), zoom: 13),
        ),
      );
    }
  }

  void unselectExpense() {
    _selectedExpense = null;
    notifyListeners();
    // hideBottomSheet();
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  Future<void> locateUser() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((e, StackTrace) {
      print('error$e');
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _currentLocation = LatLng(position.latitude, position.longitude);
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation!, zoom: 13),
        ),
      );
    }
    notifyListeners();
  }

  Future<void> searchAndNavigate(String query) async {
    try {
      final locations = await placesService.searchPlaces(query);
      if (locations.isNotEmpty) {
        final latLng = locations.first;
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: latLng, zoom: 13),
            ),
          );
        }
      }
    } catch (e) {
      print('Failed to search and navigate: $e');
    }
  }

  Future<List<String>> autocompleteSuggestions(String query) async {
    try {
      return await placesService.autocompletePlaces(query);
    } catch (e) {
      print('Failed to get autocomplete suggestions: $e');
      return [];
    }
  }

  void updateSearchText(String newText) {
    searchController.text = newText;
    notifyListeners();
  }
}
