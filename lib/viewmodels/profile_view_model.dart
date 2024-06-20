import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  User? _user;
  bool _receiveInboxMessage = true;
  int _currentIndex = 4;

  User? get user => _user;
  bool get receiveInboxMessage => _receiveInboxMessage;
  int get currentIndex => _currentIndex;

  ProfileViewModel() {
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      _user = await _userService.fetchUserProfile();
      _receiveInboxMessage = _user!.notificationSettings.inboxMessageToggle.enabled;
      notifyListeners();
    } catch (e) {
      // handle error
    }
  }

  void toggleReceiveInboxMessage(bool value) {
    _receiveInboxMessage = value;
    if (_user != null) {
      final updatedInboxMessageToggle = InboxMessageToggle(enabled: value);
      final updatedNotificationSettings = NotificationSettings(
        emailNotifications: _user!.notificationSettings.emailNotifications,
        pushNotifications: _user!.notificationSettings.pushNotifications,
        inboxMessageToggle: updatedInboxMessageToggle,
      );
      _user = User(
        userId: _user!.userId,
        nickname: _user!.nickname,
        email: _user!.email,
        emailVerified: _user!.emailVerified,
        role: _user!.role,
        profile: _user!.profile,
        notificationSettings: updatedNotificationSettings,
      );
      _userService.updateNotificationSettings(updatedNotificationSettings);
      notifyListeners();
    }
  }

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
