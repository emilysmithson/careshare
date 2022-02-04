import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';

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
        width: 250,
        height: 190,
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        color: Colors.blue[50],
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                return Wrap(
                  runSpacing: 4,
                  children: [
                    Row(
                      children: [
                        ProfilePhotoWidget(
                            size: 50, id: task.acceptedBy ?? task.createdBy),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: 'Priority: '),
                                  TextSpan(
                                    text: task.taskPriority.level,
                                    style: TextStyle(
                                        color: task.taskPriority.color),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Difficulty: ${task.taskEffort.size}'),
                            const SizedBox(height: 4),
                            if (task.category != null)
                              Text('Type: ${task.category!.name}'),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    if (task.taskStatus == TaskStatus.created)
                      Text(
                        'Created by: ${BlocProvider.of<ProfileCubit>(context).getName(task.createdBy)}',
                      ),
                    Text(
                      'Created by: ${BlocProvider.of<ProfileCubit>(context).getName(task.createdBy)}',
                    ),
                    Text(
                      task.acceptedBy == null || task.acceptedBy!.isEmpty
                          ? 'Not currently assigned' // to anyone'
                          : 'Assigned to: ${BlocProvider.of<ProfileCubit>(context).getName(task.acceptedBy!)}',
                    ),
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
