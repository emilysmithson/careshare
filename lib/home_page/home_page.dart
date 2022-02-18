import 'package:careshare/task_manager/presenter/task_manager_view.dart';
import 'package:careshare/templates/page_scaffold.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/home-page";
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Navigator.pushNamed(context, TaskManagerView.routeName);
    return PageScaffold(
      body: Center(
          child: ElevatedButton(
        child: const Text('Task Manager'),
        onPressed: () {
          Navigator.pushNamed(context, TaskManagerView.routeName);
        },
      )),
    );
  }
}
