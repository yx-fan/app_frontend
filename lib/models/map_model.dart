class Receipt {
  final String id;
  final String name;
  final DateTime date;
  final double amount;
  // final String currency;
  final double latitude;
  final double longitude;

  Receipt({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    // required this.currency,
    required this.latitude,
    required this.longitude,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['_id'],
      name: json['merchantName'],
      date: DateTime.parse(json['date']),
      amount: json['amount'].toDouble(),
      // currency: json['currency'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'title': title,
  //     'date': date.toIso8601String(),
  //     'amount': amount,
  //     'currency': currency,
  //   };
  // }
}
