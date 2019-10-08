import 'package:flutter/material.dart';
import 'TodoList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Todo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: TodoList()
    );
  }
}
