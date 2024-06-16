import 'package:flutter/material.dart';

class ThemeButtonSmall extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  ThemeButtonSmall({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Color.fromARGB(194, 241, 147, 6), // Button background color
          foregroundColor: Colors.white, // Button text color
        ));
  }
}
