import 'package:flutter/material.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({Key? key}) : super(key: key);

  @override
  _TaskManagerScreenState createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('hello')));
  }
}
