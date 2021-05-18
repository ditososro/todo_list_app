import 'package:flutter/material.dart';
import 'package:todo_list_app/todo_list_screen.dart';
import 'package:todo_list_app/add_task.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoList()
    );
  }
}

