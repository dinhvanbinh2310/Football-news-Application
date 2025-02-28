import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/ticket_model.dart';

class TicketService {
  static const String apiUrl = 'http://localhost:3000/tickets';

  static Future<List<Ticket>> fetchTickets() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Ticket.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
