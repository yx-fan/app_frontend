import 'package:app_frontend/services/expense_service.dart';
import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class TripExpenseViewModel extends ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();
  List<Expense> _filteredExpenses = [];
  List<Expense> _Expenses = [];
  List<Expense> _starredExpenses = [];
  List<String> _categories = [];

  static final _categoryMap = {
    1: "Transportation",
    2: "Food",
    3: "Entertainment",
    4: "Accommodation",
    5: "Shopping",
    6: "Other"
  };

  List<Expense> get starredExpenses => _starredExpenses;
  List<Expense> get expenses =>
      _categories.isNotEmpty ? _filteredExpenses : _Expenses;
  List<Expense> get filteredExpenses => _filteredExpenses;

  TripExpenseViewModel({required String tripId}) {
    fetchExpenseDetails(tripId);
  }

  Future<void> fetchExpenseDetails(String tripId) async {
    try {
      _Expenses = await _expenseService.fetchExpenses(tripId);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Failed to load trip details: $e");
    }
  }

  void filterAndSortExpenses(List<String> categories, String sortOption) {
    _categories = categories;
    _filteredExpenses = _Expenses.where((expense) {
      return categories.isEmpty ||
          categories.contains(_categoryMap[expense.category]);
    }).toList();

    if (sortOption == 'Newest') {
      _filteredExpenses.sort((a, b) => b.date.compareTo(a.date));
    } else if (sortOption == 'Amount: Low to High') {
      _filteredExpenses.sort((a, b) => a.amount.compareTo(b.amount));
    } else if (sortOption == 'Amount: High to Low') {
      _filteredExpenses.sort((a, b) => b.amount.compareTo(a.amount));
    }
    notifyListeners();
  }

  void toggleStarredExpense(Expense expense) {
    if (_starredExpenses.contains(expense)) {
      _starredExpenses.remove(expense);
    } else {
      _starredExpenses.add(expense);
    }
    notifyListeners();
  }
}
