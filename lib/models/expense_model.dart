class Expense {
  final String id;
  final int category;
  final String merchantName;
  final DateTime date;
  final double amount;
  final String location;
  final String postalCode;
  final String description;
  final double longitude;
  final double latitude;

  Expense({
    required this.id,
    required this.merchantName,
    required this.amount,
    required this.date,
    required this.category,
    required this.location,
    required this.postalCode,
    required this.description,
    required this.longitude,
    required this.latitude,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'],
      merchantName: json['merchantName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      category: (json['category'] ?? 0).toInt(),
      location: json['location'] ?? '',
      postalCode: json['postalCode'] ?? '',
      description: json['description'] ?? '',
      longitude: (json['longitude'] ?? 0).toDouble(),
      latitude: (json['latitude'] ?? 0).toDouble(),
    );
  }

  static List<Expense> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Expense.fromJson(json)).toList();
  }
}
