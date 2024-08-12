class Notification {
  final String id;
  final String user;
  final String title;
  final String message;
  final String? note; // Note is now optional
  final DateTime date;
  bool isReverted;

  Notification(
      {required this.id,
      required this.user,
      required this.title,
      required this.message,
      this.note, // Optional parameter
      required this.date,
      required this.isReverted});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id'],
      user: json['user'],
      title: json['title'],
      message: json['message'],
      note: json['note'], // Can be null
      date: DateTime.parse(json['createdAt']),
      isReverted: true,
    );
  }
}
