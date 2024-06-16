import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_view_model.dart';
import '../components/theme_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/login_icon.png',
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sign in to ExpenseTrack',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Welcome back to manage your expenses'),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: (value) {
                        viewModel.email = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        viewModel.password = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    if (viewModel.isLoading)
                      const CircularProgressIndicator()
                    else
                      ThemeButton(
                        text: 'Log in',
                        onPressed: () async {
                          bool success = await viewModel.login();
                          if (success) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/tripView', (route) => false);
                          }
                        },
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {},
                            ),
                            const Text('Remember me'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          child: const Text('Forgot your password?'),
                        ),
                      ],
                    ),
                    if (viewModel.errorMessage.isNotEmpty)
                      Text(
                        viewModel.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup_step1');
                      },
                      child: const Text('Create an account to start tracking'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                        'Terms of Service | Privacy Policy | Contact Us'),
                    const SizedBox(height: 10),
                    const Text('© 2024 ExpenseTrack'),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
