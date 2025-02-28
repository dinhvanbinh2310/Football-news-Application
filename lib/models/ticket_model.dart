class Ticket {
  final String id;
  final String eventName;
  final int price;
  final String seat;
  final String status;

  Ticket({
    required this.id,
    required this.eventName,
    required this.price,
    required this.seat,
    required this.status,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'],
      eventName: json['eventName'],
      price: json['price'],
      seat: json['seat'],
      status: json['status'],
    );
  }
}
