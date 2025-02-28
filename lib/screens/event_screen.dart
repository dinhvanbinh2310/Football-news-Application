import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ticket_model.dart';
import 'package:flutter_application_1/services/ticket_service.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late Future<List<Ticket>> tickets;

  @override
  void initState() {
    super.initState();
    tickets = TicketService.fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách vé sự kiện'),
      ),
      body: FutureBuilder<List<Ticket>>(
        future: tickets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có vé nào'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ticket = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(ticket.eventName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text('Giá vé: \$${ticket.price}', style: TextStyle(fontSize: 16)),
                        Text('Chỗ ngồi: ${ticket.seat}', style: TextStyle(fontSize: 16)),
                        Text('Trạng thái: ${ticket.status}', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
