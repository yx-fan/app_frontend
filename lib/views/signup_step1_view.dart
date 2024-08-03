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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join ExpenseTrack!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          controller: signUpViewModel.emailController,
                          decoration: const InputDecoration(
                            labelText: 'Enter your email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 100,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isButtonDisabled
                            ? null
                            : () async {
                          bool success = await signUpViewModel.sendVerificationEmail();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Verification email sent. Please check your email.'
                                    : signUpViewModel.errorMessage!,
                              ),
                            ),
                          );
                          if (success) {
                            startTimer();
                          }
                        },
                        child: _isButtonDisabled
                            ? Text('Resend ($_start)')
                            : const Text('Send'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ThemeButtonLarge(
                  text: 'Next',
                  onPressed: () async {
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
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Existing user? Sign in',
                    style: TextStyle(color: Colors.black),
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
