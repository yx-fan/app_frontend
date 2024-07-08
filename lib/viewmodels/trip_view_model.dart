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
      String description, String selectedCurrency) async {
    bool success = false;
    try {
      success = await _tripService.createTrip(
          tripName, startDate, endDate, description, selectedCurrency);
    } catch (e) {
      print(e);
    }
    return success;
  }

  void updateAmt(String tripId, double oldAmt, double newAmt) {
    for (var trip in _trips) {
      if (trip.tripId == tripId) {
        trip.totalAmt = trip.totalAmt - oldAmt + newAmt;
        notifyListeners();
        break;
      }
    }
  }

  void updateCnt(String tripId, int indicator, double amt) {
    // indicator = 0 for delete & amt should be the amt to be reduced, inicator = 1 for add & amt should be the amt to be added
    for (var trip in _trips) {
      if (trip.tripId == tripId) {
        if (indicator == 0) {
          trip.totalCnt -= 1;
          trip.totalAmt -= amt;
          notifyListeners();
        } else {
          trip.totalCnt += 1;
          trip.totalAmt += amt;
          notifyListeners();
        }
        break;
      }
    }
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
