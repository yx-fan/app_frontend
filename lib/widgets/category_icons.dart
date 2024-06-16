import 'package:flutter/material.dart';

class CategoryIcons {
  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'transportation':
        return Icons.flight;
      case 'food':
        return Icons.restaurant;
      case 'entertainment':
        return Icons.movie;
      case 'accommodation':
        return Icons.hotel;
      case 'shopping':
        return Icons.shopping_bag;
      case 'other':
      default:
        return Icons.category;
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'transportation':
        return Color.fromARGB(255, 234, 187, 238);
      case 'food':
        return Color.fromARGB(204, 244, 213, 122);
      case 'entertainment':
        return Color.fromARGB(235, 167, 168, 236);
      case 'accommodation':
        return Color.fromARGB(255, 220, 182, 126);
      case 'shopping':
        return Color.fromARGB(255, 249, 161, 161);
      case 'other':
      default:
        return Color.fromARGB(255, 238, 165, 165);
    }
  }
}
