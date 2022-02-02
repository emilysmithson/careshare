import 'package:careshare/profile_manager/cubit/profile_cubit.dart';

import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';

import 'package:careshare/task_manager/presenter/task_widgets/category_picker.dart';

import 'package:careshare/task_manager/presenter/task_widgets/display_comments_widget.dart';

import 'package:careshare/task_manager/presenter/task_widgets/task_input_field_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'task_widgets/assign_to_widget.dart';

class TaskDetailedView extends StatelessWidget {
  final CareTask task;

  const TaskDetailedView({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double spacing = 16;

    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              final String? createdByPhoto =
                  BlocProvider.of<ProfileCubit>(context)
                      .getPhoto(task.createdBy);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: spacing),
                  TaskInputFieldWidget(
                    label: 'Title',
                    maxLines: 1,
                    currentValue: task.title,
                    task: task,
                    onChanged: (value) {
                      BlocProvider.of<TaskCubit>(context)
                          .editTaskFieldRepository(
                        taskField: TaskField.title,
                        task: task,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  CategoryPicker(task: task),
                  const SizedBox(height: spacing),
                  CategoryPicker(task: task),
                  const SizedBox(height: spacing),
                  Row(
                    children: [
                      if (createdByPhoto != null)
                        Center(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(createdByPhoto),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                      Text(
                        'Created by: ${BlocProvider.of<ProfileCubit>(context).getName(task.createdBy)} on ${DateFormat('E').add_jm().format(task.dateCreated)}',
                      ),
                    ],
                  ),
                  const SizedBox(height: spacing),
                  TaskInputFieldWidget(
                    label: 'Description',
                    maxLines: 5,
                    currentValue: task.details,
                    task: task,
                    onChanged: (value) {
                      BlocProvider.of<TaskCubit>(context)
                          .editTaskFieldRepository(
                        task: task,
                        newValue: value,
                        taskField: TaskField.details,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  AssignToWidget(
                    task: task,
                  ),
                  const SizedBox(height: spacing),
                  Text('Priority: ${task.taskPriority.level}'),
                  Slider(
                    label: task.taskPriority.level,
                    value: task.taskPriority.value.toDouble(),
                    min: 1,
                    activeColor: Colors.grey,
                    inactiveColor: Colors.grey,
                    max: 5,
                    thumbColor: task.taskPriority.color,
                    divisions: 4,
                    onChanged: (value) {
                      BlocProvider.of<TaskCubit>(context).editTask(
                        task: task,
                        newValue: value,
                        taskField: TaskField.taskPriority,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  Text('Effort Required: ${task.taskEffort.definition}'),
                  Slider(
                    label: task.taskEffort.definition,
                    value: task.taskEffort.value.toDouble(),
                    min: 1,
                    activeColor: Colors.grey,
                    inactiveColor: Colors.grey,
                    max: 6,
                    divisions: 5,
                    onChanged: (value) {
                      BlocProvider.of<TaskCubit>(context).editTask(
                        task: task,
                        newValue: value,
                        taskField: TaskField.taskEffort,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  const SizedBox(height: spacing),
                  DisplayCommentsWidget(task: task),
                  const SizedBox(height: spacing),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Save')),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          final taskCubit = BlocProvider.of<TaskCubit>(context);

                          taskCubit.removeTask(task.id);
                        },
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
