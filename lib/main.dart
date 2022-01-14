import 'package:flutter/material.dart';
import 'package:puzzle_hack/ui/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(backgroundColor: Colors.white, primaryColor: Colors.blue),
      home: Home(),
    );
  }
}
