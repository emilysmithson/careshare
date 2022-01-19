import 'package:careshare/profile/usecases/fetch_profiles.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskSummary extends StatelessWidget {
  final CareTask task;
  final FetchProfiles profileModule;
  const TaskSummary({
    Key? key,
    required this.task,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}