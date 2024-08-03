import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/signup_view_model.dart';
import '../widgets/theme_button_large.dart';

class SignUpStep2View extends StatelessWidget {
  const SignUpStep2View({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain view model
    final signUpViewModel = Provider.of<SignUpViewModel>(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/signup_background.webp',
            fit: BoxFit.cover,
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
                      color: Colors.black),
                ),
                const SizedBox(height: 60),
                TextField(
                  controller: signUpViewModel.passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: signUpViewModel.confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm your password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
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
                      style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Existing user? Sign in',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
