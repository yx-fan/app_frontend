import 'package:app_frontend/services/expense_service.dart';
import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class TripExpenseViewModel extends ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();
  List<Expense> _filteredExpenses = [];
  List<Expense> _expenses = [];
  List<Expense> _starredExpenses = [];
  List<String> _categories = [];

  final Map<int, String> _categoryMap = { // 改为非静态变量
    1: "Transportation",
    2: "Food",
    3: "Entertainment",
    4: "Accommodation",
    5: "Shopping",
    6: "Other"
  };

  List<Expense> get starredExpenses => _starredExpenses;
  List<Expense> get expenses => _categories.isNotEmpty ? _filteredExpenses : _expenses;
  List<Expense> get filteredExpenses => _filteredExpenses;
  Map<int, String> get categoryMap => _categoryMap; // 添加 getter 访问器

  TripExpenseViewModel({required String tripId}) {
    fetchExpenseDetails(tripId);
  }

  Future<void> fetchExpenseDetails(String tripId) async {
    try {
      _expenses = await _expenseService.fetchExpenses(tripId);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Failed to load trip details: $e");
    }
  }

  void filterAndSortExpenses(List<String> categories, String sortOption) {
    _categories = categories;
    _filteredExpenses = _expenses.where((expense) {
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

  void updateExpense(Expense updatedExpense) {
    int index = _expenses.indexWhere((expense) => expense.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      notifyListeners();
    }
  }

  Future<void> saveChanges(Expense originalExpense, Expense updatedExpense) async {
    try {
      // 创建一个 map 来存储需要更新的字段
      final updates = <String, dynamic>{};

      if (originalExpense.merchantName != updatedExpense.merchantName) {
        updates['merchantName'] = updatedExpense.merchantName ?? '';
      }
      if (originalExpense.date != updatedExpense.date) {
        updates['date'] = updatedExpense.date.toIso8601String();
      }
      if (originalExpense.amount != updatedExpense.amount) {
        updates['amount'] = updatedExpense.amount ?? 0.0;
      }
      if (originalExpense.location != updatedExpense.location) {
        updates['location'] = updatedExpense.location ?? '';
      }
      if (originalExpense.description != updatedExpense.description) {
        updates['description'] = updatedExpense.description ?? '';
      }
      if (originalExpense.category != updatedExpense.category) {
        updates['category'] = updatedExpense.category ?? 6;
      }

      // Update to database only any field changes
      if (updates.isNotEmpty) {
        final response = await _expenseService.updateExpense(updatedExpense.id, updates);
        updateExpense(response); // update local data
      }
    } catch (e) {
      print('Failed to update expense: $e');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await _expenseService.deleteExpense(expenseId);
      _expenses.removeWhere((expense) => expense.id == expenseId);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Failed to delete expense: $e');
    }
  }
}
