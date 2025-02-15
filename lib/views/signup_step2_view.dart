import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/signup_view_model.dart';
import '../widgets/theme_button_large.dart';

class SignUpStep2View extends StatefulWidget {
  const SignUpStep2View({super.key});

  @override
  _SignUpStep2ViewState createState() => _SignUpStep2ViewState();
}

class _SignUpStep2ViewState extends State<SignUpStep2View> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // Obtain view model
    final signUpViewModel = Provider.of<SignUpViewModel>(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with reduced opacity
          Image.asset(
            'assets/signup_background.webp',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.5), // Adjust opacity here
            colorBlendMode: BlendMode.darken, // Blend the color with the image
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Text(
                  'Join ExpenseTrack!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // Changed text color to white
                ),
                const SizedBox(height: 60),
                TextField(
                  controller: signUpViewModel.passwordController,
                  decoration: InputDecoration(
                    labelText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: signUpViewModel.confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm your password',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                ),
                const SizedBox(height: 20),
                if (signUpViewModel.errorMessage != null)
                  Text(
                    signUpViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                ThemeButtonLarge(
                  text: 'Sign up',
                  onPressed: () async {
                    bool success = await signUpViewModel.register();
                    if (success) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup_step1');
                  },
                  child: const Text('Didn\'t receive it? Resend',
                      style: TextStyle(color: Colors.white)), // Changed text color to white
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Existing user? Sign in',
                      style: TextStyle(color: Colors.white)), // Changed text color to white
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
