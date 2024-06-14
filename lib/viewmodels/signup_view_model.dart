import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? errorMessage;
  final AuthService _authService = AuthService();

  Future<bool> sendVerificationEmail() async {
    final email = emailController.text;
    bool success = await _authService.sendVerificationEmail(email);
    if (!success) {
      errorMessage = "Failed to send verification email";
      notifyListeners();
    }
    return success;
  }

  Future<bool> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage = "Passwords do not match";
      notifyListeners();
      return false;
    }

    final email = emailController.text;
    final password = passwordController.text;
    bool success = await _authService.register(email, password);
    if (!success) {
      errorMessage = "Registration failed";
      notifyListeners();
    }
    return success;
  }
}
