import 'package:careshare/task_manager/presenter/add_task_floating_action_button.dart';

import 'package:flutter/material.dart';

class TasksView extends StatefulWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const AddTaskFloatingActionButton(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox),
            label: 'All Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_outlined),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_add),
            label: 'My Tasks',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
      body: const Center(child: Text('Task page')),
    );
  }
}
