import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/signup_view_model.dart';

class SignUpStep2View extends StatelessWidget {
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Text(
                        'Join ExpenseTrack!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: viewModel.passwordController,
                        decoration: InputDecoration(
                          labelText: 'Enter your password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: viewModel.confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm your password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      if (viewModel.errorMessage != null)
                        Text(
                          viewModel.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          bool success = await viewModel.register();
                          if (success) {
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                          }
                        },
                        child: Text('Sign up'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: Size(double.infinity, 50), // match parent width
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup_step1');
                        },
                        child: Text('Didn\'t receive it? Resend', style: TextStyle(color: Colors.black)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text('Existing user? Sign in', style: TextStyle(color: Colors.black)),
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
