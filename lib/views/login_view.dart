import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_view_model.dart';
import '../widgets/theme_button_large.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginViewModel = context.read<LoginViewModel>();
      _emailController.text = loginViewModel.email;
      _passwordController.text = loginViewModel.password;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel()..loadCredentials(),  // Load credentials when screen is built
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/login_icon.png',
                        height: 100,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Sign in to Tracker',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Simplify to manage your expenses'),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        controller: _emailController,
                        onChanged: (value) {
                          viewModel.email = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        controller: _passwordController,
                        onChanged: (value) {
                          viewModel.password = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (viewModel.isLoading)
                        const CircularProgressIndicator()
                      else
                        ThemeButtonLarge(
                          text: 'Log in',
                          onPressed: () async {
                            bool success = await viewModel.login();
                            if (success) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/tripView', (route) => false);
                            } else if (viewModel.errorMessage.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(viewModel.errorMessage),
                                ),
                              );
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
                                value: viewModel.rememberMe,
                                onChanged: (value) {
                                  viewModel.rememberMe = value ?? false;
                                },
                              ),
                              const Text('Remember me'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('This feature is not available yet.'),
                                ),
                              );
                            },
                            child: const Text('Forgot your password?'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup_step1');
                        },
                        child: const Text('Create an account to start tracking'),
                      ),
                      const SizedBox(height: 20),
                      const Text('Terms of Service | Privacy Policy | Contact Us'),
                      const SizedBox(height: 10),
                      const Text('© 2024 TravelExpenseTracker'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
