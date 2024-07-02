import 'package:flutter/material.dart';
import '../models/notification_model.dart' as nm;
import '../services/notification_service.dart';

class InboxViewModel extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<nm.Notification> _notifications = [];
  List<nm.Notification> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  InboxViewModel() {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _notificationService.fetchNotifications();
    } catch (e) {
      print('Failed to load notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int _currentIndex = 3;
  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
