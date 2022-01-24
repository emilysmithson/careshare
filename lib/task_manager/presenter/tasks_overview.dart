import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_widgets/task_summary.dart';
import 'package:flutter/material.dart';

class TasksOverview extends StatelessWidget {
  final List<CareTask> careTaskList;
  const TasksOverview({Key? key, required this.careTaskList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: careTaskList
            .map(
              (task) => TaskSummary(
                task: task,
              ),
            )
            .toList(),
      ),
    );
  }
}
