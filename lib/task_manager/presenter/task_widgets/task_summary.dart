import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskSummary extends StatelessWidget {
  final CareTask task;

  const TaskSummary({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<TaskCubit>(context).showTaskDetails(task);
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
                // const SizedBox(height: 8),
                // Text(
                //   'Created by: ${profileModule.getNickName(task.createdBy)} on ${DateFormat('E').add_jm().format(task.dateCreated)}',
                // ),
                // const SizedBox(height: 8),
                // Text(
                //   task.acceptedBy == null || task.acceptedBy!.isEmpty
                //       ? 'Not currently assigned to anyone'
                //       : 'Assigned to: ${profileModule.getNickName(task.acceptedBy!)} on ${DateFormat('E').add_jm().format(task.acceptedOnDate!)}',
                // ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        final taskCubit = BlocProvider.of<TaskCubit>(context);

                        taskCubit.removeTask(task.id);
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
