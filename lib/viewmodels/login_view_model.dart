import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _errorMessage = '';

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String get errorMessage => _errorMessage;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      bool success = await _authService.login(_email, _password);
      if (success) {
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
      }
    } catch (e) {
      _errorMessage = 'An error occurred';
      print('LoginViewModel login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      bool tokenExists = await _authService.checkTokenExists();
      _isLoggedIn = tokenExists;
    } catch (e) {
      _errorMessage = 'An error occurred';
    }

    _isLoading = false;
    notifyListeners();
  }
}
