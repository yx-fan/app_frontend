import 'package:app_frontend/services/trip_service.dart';
import 'package:flutter/material.dart';
import '../models/trip_model.dart';

class TripViewModel extends ChangeNotifier {
  final TripService _tripService = TripService();
  List<Trip> _trips = [];
  int _currentIndex = 0;

  List<Trip> get trips => _trips;
  int get currentIndex => _currentIndex;

  TripViewModel() {
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    try {
      _trips = await _tripService.fetchTrips();
      notifyListeners();
    } catch (e) {
      // handle error
    }
  }

  Future<bool> createTrip(String tripName, DateTime startDate, DateTime endDate,
      String description) async {
    bool success = false;
    try {
      success = await _tripService.createTrip(
          tripName, startDate, endDate, description);
    } catch (e) {
      print(e);
    }
    return success;
  }

  void removeTrip(Trip trip) {
    _trips.remove(trip);
    notifyListeners();
  }

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
