import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../models/trip_model.dart';
import '../services/trip_service.dart';
import '../services/expense_service.dart';

class StarViewModel extends ChangeNotifier {
  final TripService _tripService = TripService();
  final ExpenseService _expenseService = ExpenseService();
  List<String> _categories = [];
  List<Trip> _trips = [];

  final Map<int, String> _categoryMap = {
    1: "Transportation",
    2: "Food",
    3: "Entertainment",
    4: "Accommodation",
    5: "Shopping",
    6: "Other"
  };

  Map<int, String> get categoryMap => _categoryMap;

  final Map<String, List<Expense>> _starredExpenses = {};
  Map<String, List<Expense>> _filteredExpenses = {};

  List<Trip> get trips => _trips;

  Map<String, List<Expense>> get starredExpenses => _starredExpenses;
  Map<String, List<Expense>> get filteredExpenses => _filteredExpenses;

  StarViewModel() {
    fetchStarred();
  }

  Future<void> fetchStarred() async {
    try {
      _trips = await _tripService.fetchTrips();
      for (var trip in _trips) {
        List<Expense> expenses =
            await _expenseService.fetchExpenses(trip.tripId);
        List<Expense> starredExpenses =
            expenses.where((expense) => expense.starred).toList();
        starredExpenses.sort((a, b) => b.date.compareTo(a.date));
        if (starredExpenses.isNotEmpty) {
          _starredExpenses[trip.tripId] = starredExpenses;
        }
      }
      _filteredExpenses = _starredExpenses;
      notifyListeners();
    } catch (e) {
      // handle error
    }
  }

  void toggleStarredExpense(String tripId, Expense expense) {
    // Toggle the starred status of the Expense
    expense.starred = !expense.starred;

    if (expense.starred) {
      if (!_starredExpenses.containsKey(tripId)) {
        _starredExpenses[tripId] = [];
      }
      _starredExpenses[tripId]?.add(expense);
    } else {
      _starredExpenses[tripId]?.removeWhere((e) => e.id == expense.id);
    }

    Map<String, dynamic> updates = {
      'starred': expense.starred,
    };
    _expenseService.updateExpense(expense.id, updates);

    // Remove the trip from the map if there are no starred expenses left
    if (_starredExpenses[tripId]?.isEmpty ?? true) {
      _starredExpenses.remove(tripId);
    }

    notifyListeners();
  }

  void updateExpense(String tripId, Expense updatedExpense) {
    int index = _starredExpenses[tripId]
            ?.indexWhere((exp) => exp.id == updatedExpense.id) ??
        -1;
    if (index != -1) {
      _starredExpenses[tripId]?[index] = updatedExpense;
      notifyListeners();
    }
  }

  void filterAndSortExpenses(List<String> categories, String sortOption) {
    _categories = categories;

    _starredExpenses.forEach((tripId, expenses) {
      List<Expense> filtered = expenses.where((expense) {
        return categories.isEmpty ||
            categories.contains(_categoryMap[expense.category]);
      }).toList();

      if (sortOption == 'Newest') {
        filtered.sort((a, b) => b.date.compareTo(a.date));
      } else if (sortOption == 'Amount: Low to High') {
        filtered.sort((a, b) => a.amount.compareTo(b.amount));
      } else if (sortOption == 'Amount: High to Low') {
        filtered.sort((a, b) => b.amount.compareTo(a.amount));
      }

      if (filtered.isNotEmpty) {
        _filteredExpenses[tripId] = filtered;
      }
    });

    notifyListeners();
  }

  void cleanUpStarred(String tripId) {
    print("clean up starred");
    // Remove the trip from the trips list;
    _trips.removeWhere((trip) => trip.tripId == tripId);

    // Remove the trip's starred expenses
    _starredExpenses.remove(tripId);

    // Remove the trip's filtered expenses
    _filteredExpenses.remove(tripId);

    notifyListeners();
  }

  void revertStarred(String tripId) async {
    Trip? trip;
    trip = await _tripService.getOneTrip(tripId);
    if (trip != null) {
      _trips.add(trip);
    }

    List<Expense> expenses = await _expenseService.fetchExpenses(tripId);

    _starredExpenses[tripId] = expenses;
    _filteredExpenses[tripId] = expenses;

    notifyListeners();
  }
}
