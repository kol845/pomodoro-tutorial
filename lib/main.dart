import 'package:flutter/material.dart';
import 'package:pomodoro/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Home(),
    );
    return materialApp;
  }
}
