import 'expense.dart';

class Trip {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<Expense> expenses;
  double totalExpense;
  final String imageUrl;

  Trip({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.totalExpense,
    required this.imageUrl,
    this.expenses = const [],
  });
}
