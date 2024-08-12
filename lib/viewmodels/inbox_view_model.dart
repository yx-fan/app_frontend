import 'package:flutter/material.dart';
import '../models/notification_model.dart' as nm;
import '../services/notification_service.dart';
import '../models/trip_model.dart';

class InboxViewModel extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<nm.Notification> _notifications = [];
  List<nm.Notification> get notifications => _notifications;

  List<Trip> _deletedTrips = [];
  List<Trip> get deletedTrips => _deletedTrips;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  InboxViewModel() {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    print("fetching!");

    try {
      // Fetch notifications and deleted trips
      _notifications = await _notificationService.fetchNotifications();
      _deletedTrips = await _notificationService.fetchDeletedTrips();

      // Iterate over each notification
      for (var notification in _notifications) {
        if (notification.title == "Trip Deleted") {
          // Check if the notification's note matches any trip ID
          for (var trip in _deletedTrips) {
            if (notification.note == trip.tripId) {
              notification.isReverted = false;
            }
          }
        }
      }
    } catch (e) {
      print('Failed to load notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void revertNotification(String tripId) {
    // Iterate over each notification
    for (var notification in _notifications) {
      if (notification.title == "Trip Deleted" && notification.note == tripId) {
        notification.isReverted = true;
      }
    }
    notifyListeners();
  }

  int _currentIndex = 3;
  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
