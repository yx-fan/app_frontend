import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../models/expense_model.dart';

class TripViewModel extends ChangeNotifier {
  List<Trip> _trips = [
    Trip(
      name: "Business Trip",
      description: "Business trip to the mountains.",
      startDate: DateTime(2024, 6, 2),
      endDate: DateTime(2024, 6, 5),
      totalExpense: 0.0,
      imageUrl: 'assets/mountain.jpg',
    ),
    Trip(
      name: "Japan Trip",
      description: "Leisure trip to Japan.",
      startDate: DateTime(2024, 6, 2),
      endDate: DateTime(2024, 6, 15),
      totalExpense: 1023.0,
      expenses: [
        Expense(
            title: "Air Canada",
            amount: 1000,
            date: DateTime(2024, 1, 2),
            category: 'transportation'),
        Expense(
            title: "Restaurant Name",
            amount: 30,
            date: DateTime(2024, 1, 2),
            category: 'food'),
        Expense(
            title: "Marriott Hotel",
            amount: 1000,
            date: DateTime(2024, 1, 2),
            category: 'accommodation'),
        Expense(
            title: "National Park",
            amount: 30,
            date: DateTime(2024, 1, 2),
            category: 'entertainment'),
        Expense(
            title: "Macy",
            amount: 30,
            date: DateTime(2024, 1, 2),
            category: 'shopping'),
        Expense(
            title: "Car Insurance",
            amount: 30,
            date: DateTime(2024, 1, 2),
            category: 'other'),
      ],
      imageUrl: 'assets/japan.jpg',
    ),
  ];

  List<Trip> get trips => _trips;

  void addTrip(Trip trip) {
    _trips.add(trip);
    notifyListeners();
  }

  void removeTrip(Trip trip) {
    _trips.remove(trip);
    notifyListeners();
  }

  void addExpense(Trip trip, Expense expense) {
    trip.expenses.add(expense);
    trip.totalExpense += expense.amount;
    notifyListeners();
  }

  void removeExpense(Trip trip, Expense expense) {
    trip.expenses.remove(expense);
    trip.totalExpense -= expense.amount;
    notifyListeners();
  }
}
