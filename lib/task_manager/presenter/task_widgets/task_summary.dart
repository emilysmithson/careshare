import 'package:careshare/profile/usecases/fetch_profiles.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_view.dart';
import 'package:careshare/task_manager/presenter/task_widgets/assign_to_widget.dart';
import 'package:careshare/task_manager/usecases/fetch_tasks.dart';
import 'package:careshare/task_manager/usecases/remove_a_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskSummary extends StatelessWidget {
  final CareTask task;
  final FetchProfiles profileModule;
  final FetchTasks fetchTasks;
  const TaskSummary({
    Key? key,
    required this.task,
    required this.fetchTasks,
    required this.profileModule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskView(
              fetchTasks: fetchTasks,
              task: task,
              profileModule: profileModule,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${task.title}',
                ),
                const SizedBox(height: 8),
                Text(
                  'Description: ${task.details}',
                ),
                const SizedBox(height: 8),
                Text(
                  'Created by: ${profileModule.getNickName(task.createdBy)} on ${DateFormat('E').add_jm().format(task.dateCreated)}',
                ),
                const SizedBox(height: 8),
                Text(
                  task.acceptedBy == null || task.acceptedBy!.isEmpty
                      ? 'Not currently assigned to anyone'
                      : 'Assigned to: ${profileModule.getNickName(task.acceptedBy!)} on ${DateFormat('E').add_jm().format(task.acceptedOnDate!)}',
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        final removeTask = RemoveATask();
                        removeTask(task.id);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
