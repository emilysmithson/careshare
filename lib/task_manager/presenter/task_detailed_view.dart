import 'package:careshare/categories/cubit/categories_cubit.dart';
import 'package:careshare/categories/models/category.dart';
import 'package:careshare/profile/cubit/profile_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_priority.dart';
import 'package:careshare/task_manager/presenter/task_widgets/add_category_widget.dart';
import 'package:careshare/task_manager/presenter/task_widgets/category_picker.dart';

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

  final double spacing = 16;

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: spacing),
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
                  SizedBox(height: spacing),
                  Text(
                    'Created by: ${BlocProvider.of<ProfileCubit>(context).getName(task.createdBy)} on ${DateFormat('E').add_jm().format(task.dateCreated)}',
                  ),
                  SizedBox(height: spacing),
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
                  SizedBox(height: spacing),
                  AssignToWidget(
                    task: task,
                  ),
                  SizedBox(height: spacing),
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
                  const Text('Category'),

                  Wrap(
                    children: BlocProvider.of<CategoriesCubit>(context)
                        .categoryList
                        .map((CareCategory category) => CategoryPicker(
                              category: category,
                              task: task,
                            ))
                        .toList(),
                  ),
                  AddCategoryWidget(),
                  SizedBox(height: spacing),

                  // TaskInputFieldWidget(
                  //   label: 'Add a comment',
                  //   maxLines: 5,
                  //   currentValue: '',
                  //   task: task,
                  //   onChanged: (value) {
                  //     BlocProvider.of<TaskCubit>(context).editTask(
                  //       task: task,
                  //       newValue: Comment(commment: value),
                  //       taskField: TaskField.comments,
                  //     );
                  //   },
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Save')),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
