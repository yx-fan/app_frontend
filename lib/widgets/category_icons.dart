import 'package:flutter/material.dart';

class CategoryIcons {
  static const int transportation = 1;
  static const int food = 2;
  static const int entertainment = 3;
  static const int accommodation = 4;
  static const int shopping = 5;
  static const int other = 6; // Represent other as 6

  IconData getCategoryIcon(int category) {
    switch (category) {
      case transportation:
        return Icons.flight;
      case food:
        return Icons.restaurant;
      case entertainment:
        return Icons.movie;
      case accommodation:
        return Icons.hotel;
      case shopping:
        return Icons.shopping_bag;
      default: // Handle other as any value >= 6
        return Icons.category;
    }
  }

  Color getCategoryColor(int category) {
    switch (category) {
      case transportation:
        return const Color.fromARGB(255, 234, 187, 238);
      case food:
        return const Color.fromARGB(204, 244, 213, 122);
      case entertainment:
        return const Color.fromARGB(235, 167, 168, 236);
      case accommodation:
        return const Color.fromARGB(255, 220, 182, 126);
      case shopping:
        return const Color.fromARGB(255, 249, 161, 161);
      default: // Handle other as any value >= 6
        return const Color.fromARGB(255, 238, 165, 165);
    }
  }
}
