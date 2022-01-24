import 'package:careshare/categories/cubit/categories_cubit.dart';
import 'package:careshare/profile/cubit/profile_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view.dart';

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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<TaskCubit>(context),
              child: BlocProvider.value(
                value: BlocProvider.of<ProfileCubit>(context),
                child: BlocProvider.value(
                  value: BlocProvider.of<CategoriesCubit>(context),
                  child: TaskDetailedView(
                    task: task,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 190,
        height: 250,
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    Text(
                      'Created by: ${BlocProvider.of<ProfileCubit>(context).getName(task.createdBy)}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.acceptedBy == null || task.acceptedBy!.isEmpty
                          ? 'Not currently assigned to anyone'
                          : 'Assigned to: ${BlocProvider.of<ProfileCubit>(context).getName(task.acceptedBy!)}',
                    ),
                    Row(
                      children: [
                        const Text('Priority: '),
                        Text(
                          task.taskPriority.level,
                          style: TextStyle(color: task.taskPriority.color),
                        ),
                      ],
                    ),
                    Text('Effort: ${task.taskEffort.definition}'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () {
                            final taskCubit =
                                BlocProvider.of<TaskCubit>(context);

                            taskCubit.removeTask(task.id);
                          },
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
