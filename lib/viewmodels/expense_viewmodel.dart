import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/expense_service.dart';

class ExpenseViewModel extends ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();
  List<ExpenseModel>? _expenses;
  bool _isLoading = false;

  List<ExpenseModel>? get expenses => _expenses;
  bool get isLoading => _isLoading;

  Future<void> fetchExpenses() async {
    _isLoading = true;
    notifyListeners();

    _expenses = await _expenseService.fetchExpenses();

    _isLoading = false;
    notifyListeners();
  }
}
