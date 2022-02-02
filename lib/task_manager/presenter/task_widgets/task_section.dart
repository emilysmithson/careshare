import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_widgets/task_summary.dart';
import 'package:flutter/material.dart';

class TaskSection extends StatelessWidget {
  final String title;
  final TaskStatus status;
  final List<CareTask> careTaskList;
  const TaskSection(
      {Key? key,
      required this.title,
      required this.status,
      required this.careTaskList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.blue[100],
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: careTaskList
                .where((element) => element.taskStatus == status)
                .map(
                  (task) => TaskSummary(
                    task: task,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}