import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/signup_view_model.dart';
import '../widgets/theme_button_large.dart';

class SignUpStep1View extends StatelessWidget {
  const SignUpStep1View({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取 SignUpViewModel 实例
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
                const Text(
                  'Join ExpenseTrack!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 60),
                TextField(
                  controller: signUpViewModel.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                if (signUpViewModel.errorMessage != null)
                  Text(
                    signUpViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                ThemeButtonLarge(
                  text: 'Next',
                  onPressed: () async {
                    bool success = await signUpViewModel.sendVerificationEmail();
                    if (success) {
                      Navigator.pushNamed(context, '/signup_step2');
                    }
                  },
                ),
                const SizedBox(height: 20),
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
