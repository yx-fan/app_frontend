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
  bool starred;

  Expense({
    required this.id,
    required this.merchantName,
    required this.amount,
    required this.date,
    required this.category,
    required this.location,
    required this.postalCode,
    required this.description,
    this.longitude = 0.0,
    this.latitude = 0.0,
    this.starred = false,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'] ?? '', // Ensure id is not null
      merchantName: json['merchantName'] ?? '', // Default to an empty string
      amount: (json['amount'] ?? 0.0).toDouble(), // Ensure amount is a double
      date: DateTime.parse(json['date'] ??
          DateTime.now().toIso8601String()), // Default to current time
      category: (json['category'] ?? 0).toInt(), // Ensure category is an int
      location: json['location'] ?? '', // Default to an empty string
      postalCode: json['postalCode'] ?? '', // Default to an empty string
      description: json['description'] ?? '', // Default to an empty string
      latitude:
          (json['latitude'] ?? 0.0).toDouble(), // Ensure latitude is a double
      longitude:
          (json['longitude'] ?? 0.0).toDouble(), // Ensure longitude is a double
      starred: json['starred'] ?? false,
    );
  }

  static List<Expense> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Expense.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantName': merchantName,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'location': location,
      'postalCode': postalCode,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'starred': starred,
    };
  }
}
