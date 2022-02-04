import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';

import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';

import 'package:careshare/task_manager/presenter/task_widgets/category_picker.dart';

import 'package:careshare/task_manager/presenter/task_widgets/display_comments_widget.dart';
import 'package:careshare/task_manager/presenter/task_widgets/effort_widget.dart';
import 'package:careshare/task_manager/presenter/task_widgets/priority_widget.dart';

import 'package:careshare/task_manager/presenter/task_widgets/task_input_field_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'task_widgets/accept_a_task.dart';

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
                  Row(
                    children: [
                      ProfilePhotoWidget(id: task.createdBy),
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
                  AcceptATask(
                    task: task,
                  ),
                  const SizedBox(height: spacing),
                  PriorityWidget(task: task),
                  const SizedBox(height: spacing),
                  EffortWidget(task: task),
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
