class Trip {
  final String tripId;
  final String currencyId;
  final String user;
  final String tripName;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  double totalAmt;
  int totalCnt;

  Trip({
    required this.tripId,
    required this.currencyId,
    required this.user,
    required this.tripName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.imageUrl, // Optional parameter
    required this.totalAmt,
    required this.totalCnt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
        tripId: json['tripId'],
        currencyId: json.containsKey('currency') && json['currency'] != null
            ? json['currency']
            : "dummy",
        user: json['user'],
        tripName: json['tripName'],
        description: json['description'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        imageUrl:
            json.containsKey('image') && json['image'].toString().isNotEmpty
                ? json['image']
                : "assets/trip_img0.jpg",
        totalAmt: (json['totalAmount'] ?? 0.0).toDouble(),
        totalCnt: (json['totalNumberOfExpenses'] ?? 0.0).toInt());
  }

  static List<Trip> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Trip.fromJson(json)).toList();
  }
}
