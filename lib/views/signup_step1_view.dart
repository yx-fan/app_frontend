import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/signup_view_model.dart';
import '../widgets/theme_button_large.dart';

class SignUpStep1View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/signup_background.webp',
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<SignUpViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Join ExpenseTrack!',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 60),
                      TextField(
                        controller: viewModel.emailController,
                        decoration: InputDecoration(
                          labelText: 'Enter your email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (viewModel.errorMessage != null)
                        Text(
                          viewModel.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 20),
                      ThemeButtonLarge(
                        text: 'Next',
                        onPressed: () async {
                          bool success =
                              await viewModel.sendVerificationEmail();
                          if (success) {
                            Navigator.pushNamed(context, '/signup_step2');
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text('Existing user? Sign in',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
