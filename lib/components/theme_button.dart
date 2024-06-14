import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  ThemeButton({required this.text, required this.onPressed});

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
        backgroundColor: Colors.orange, // Background color of the button
        foregroundColor: Colors.white,  // Text color of the button
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}