import 'package:flutter/material.dart';

class ThemeButtonSmall extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ThemeButtonSmall({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color.fromARGB(194, 241, 147, 6), // Button background color
          foregroundColor: Colors.white, // Button text color
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ));
  }
}
