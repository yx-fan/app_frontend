import 'package:flutter/material.dart';

class ThemeButtonLarge extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ThemeButtonLarge({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(194, 241, 147, 6), // Background color of the button
        foregroundColor: Colors.white, // Text color of the button
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
