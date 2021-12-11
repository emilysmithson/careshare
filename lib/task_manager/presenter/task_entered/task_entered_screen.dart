import 'package:careshare/widgets/item_widget.dart';
import 'package:flutter/material.dart';

import '../../domain/models/task.dart';
import '../create_a_task/create_a_task_screen.dart';
import '../task_manager/task_manager_screen.dart';

class TaskEnteredScreen extends StatelessWidget {
  final CareTask task;
  const TaskEnteredScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thank you for entering a task',
          ),
        ),
        body: Column(
          children: [
            itemWidget(title: 'Title', content: task.title),
            itemWidget(title: 'Description', content: task.description),
            const SizedBox(height: 200),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateATaskScreen(),
                  ),
                );
              },
              child: const Text('Enter another task'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskManagerScreen(),
                  ),
                );
              },
              child: const Text('View all tasks'),
            ),
          ],
        ));
  }
}
