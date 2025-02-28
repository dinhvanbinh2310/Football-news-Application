import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/event_screen.dart';

void main() {
    runApp(MaterialApp(
    home: EventScreen(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
