class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);
}

class Receipt {
  final String id;
  final String name;
  final DateTime date;
  final double amount;
  final String currency;
  final Location location;

  Receipt(this.id, this.name, this.date, this.amount, this.currency, this.location);
}
