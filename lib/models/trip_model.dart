class Trip {
  final String tripId;
  final String user;
  final String tripName;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;

  Trip({
    required this.tripId,
    required this.user,
    required this.tripName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.imageUrl, // Optional parameter
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['tripId'],
      user: json['user'],
      tripName: json['tripName'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      imageUrl: json.containsKey('imageUrl') && json['imageUrl'] != null
          ? json['imageUrl']
          : "assets/trip_img0.jpg",
    );
  }

  static List<Trip> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Trip.fromJson(json)).toList();
  }
}
