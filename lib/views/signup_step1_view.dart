import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/signup_view_model.dart';
import '../widgets/theme_button_large.dart';

class SignUpStep1View extends StatefulWidget {
  const SignUpStep1View({super.key});

  @override
  _SignUpStep1ViewState createState() => _SignUpStep1ViewState();
}

class _SignUpStep1ViewState extends State<SignUpStep1View> {
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _start = 60;
  bool _isButtonDisabled = false;

  void startTimer() {
    setState(() {
      _isButtonDisabled = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false;
          _start = 60;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool validateEmail(String value) {
    if (value.isEmpty) {
      showErrorSnackBar('Please enter your email');
      return false;
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      showErrorSnackBar('Please enter a valid email address');
      return false;
    }
    return true;
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 获取 SignUpViewModel 实例
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join Travel Expense Tracker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set text color to white for contrast
                  ),
                ),
                const SizedBox(height: 60),
                TextField(
                  controller: signUpViewModel.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white, // Slightly transparent white background
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : () {
                    if (validateEmail(signUpViewModel.emailController.text)) {
                      signUpViewModel.sendVerificationEmail().then((success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Verification email sent. Please check your email and click the verification link to finish the verification process.'
                                  : signUpViewModel.errorMessage!,
                            ),
                          ),
                        );
                        if (success) {
                          startTimer();
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonDisabled
                        ? Colors.grey // Disabled color
                        : const Color.fromARGB(194, 241, 147, 6), // Enabled color
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _isButtonDisabled
                        ? 'Resend ($_start)'
                        : 'Send a verification email',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ThemeButtonLarge(
                  text: 'Next',
                  onPressed: () async {
                    if (validateEmail(signUpViewModel.emailController.text)) {
                      bool isVerified = await signUpViewModel.checkEmailVerification();
                      if (isVerified) {
                        Navigator.pushNamed(context, '/signup_step2');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(signUpViewModel.errorMessage!),
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Existing user? Sign in',
                    style: TextStyle(color: Colors.white), // Set text color to white for contrast
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
