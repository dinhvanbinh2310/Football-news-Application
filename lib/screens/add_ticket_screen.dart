import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/event_model.dart';

class AddTicketScreen extends StatefulWidget {
  @override
  _AddTicketScreenState createState() => _AddTicketScreenState();
}

class _AddTicketScreenState extends State<AddTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      Event newEvent = Event(
        id: DateTime.now().toString(),
        eventName: eventNameController.text,
        price: int.parse(priceController.text),
        date: dateController.text,
      );

      // In ra console để kiểm tra dữ liệu
      print('Event Added: ${newEvent.eventName}, ${newEvent.price}, ${newEvent.date}');

      // Sau khi thêm thành công, quay về màn hình trước đó
      Navigator.pop(context, newEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Vé Sự Kiện'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: eventNameController,
                decoration: InputDecoration(labelText: 'Tên sự kiện'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên sự kiện';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Giá vé'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá vé';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Giá vé phải là số';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Ngày tổ chức (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ngày tổ chức';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTicket,
                child: Text('Thêm vé'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
