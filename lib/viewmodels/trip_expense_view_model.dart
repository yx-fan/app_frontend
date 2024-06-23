import 'package:app_frontend/services/expense_service.dart';
import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class TripExpenseViewModel extends ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();
  List<Expense> _Expenses = [];
  List<Expense> _starredExpenses = [];

  List<Expense> get starredExpenses => _starredExpenses;
  List<Expense> get expenses => _Expenses;

  TripExpenseViewModel({required String tripId}) {
    _fetchExpenseDetails(tripId);
  }

  Future<void> _fetchExpenseDetails(String tripId) async {
    try {
      _Expenses = await _expenseService.fetchExpenses(tripId);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Failed to load trip details: $e");
    }
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
