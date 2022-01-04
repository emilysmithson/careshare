import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'task_widgets/task_summary_widget.dart';
import '../domain/models/task.dart';
import 'create_or_edit_task_screen.dart';
import 'view_all_tasks_screen.dart';

class TaskEnteredScreen extends StatelessWidget {
  final CareTask task;
  const TaskEnteredScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Thank you for entering a task'),

      body: Column(
        children: [
          TaskSummaryWidget(
            task: task,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateOrEditATaskScreen()));
            },
            child: const Text('Create a new task'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewAllTasksScreen(),
                ),
              );
            },
            child: const Text('View all tasks'),
          ),
        ],
      ),
    );
  }
}
