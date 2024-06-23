class Expense {
  final String merchantName;
  final double amount;
  final DateTime date;
  final int category;

  Expense({
    required this.merchantName,
    required this.amount,
    required this.date,
    required this.category,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
        merchantName: json['merchantName'],
        amount: json['amount'].toDouble(),
        date: DateTime.parse(json['date']),
        category: json['category'].toInt());
  }

  static List<Expense> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Expense.fromJson(json)).toList();
  }
}
