class Event {
  final String id;
  final String eventName;
  final int price;
  final String date;

  Event({required this.id, required this.eventName, required this.price, required this.date});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      eventName: json['eventName'],
      price: json['price'],
      date: json['date'],
    );
  }
}
