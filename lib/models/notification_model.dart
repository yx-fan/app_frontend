class Notification {
  final String id;
  final String user;
  final String message;
  final DateTime date;

  Notification({required this.id, required this.user, required this.message, required this.date});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id'],
      user: json['user'],
      message: json['message'],
      date: DateTime.parse(json['createdAt']),
    );
  }
}
