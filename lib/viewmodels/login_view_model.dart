import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _errorMessage = '';
  bool _rememberMe = false;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set rememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> loadCredentials() async {
    _email = await _storage.read(key: 'email') ?? '';
    _password = await _storage.read(key: 'password') ?? '';
    _rememberMe = _email.isNotEmpty && _password.isNotEmpty;
    notifyListeners();
  }

  Future<void> saveCredentials() async {
    if (_rememberMe) {
      await _storage.write(key: 'email', value: _email);
      await _storage.write(key: 'password', value: _password);
    } else {
      await clearCredentials();
    }
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'password');
  }

  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      bool success = await _authService.login(_email, _password);
      if (success) {
        _isLoggedIn = true;
        await saveCredentials(); // Save credentials on successful login
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
      if (tokenExists) {
        await loadCredentials(); // Load credentials if the token exists
      }
    } catch (e) {
      _errorMessage = 'An error occurred';
    }

    _isLoading = false;
    notifyListeners();
  }
}
