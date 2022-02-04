import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';

import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';

import 'package:careshare/task_manager/presenter/task_widgets/category_widget.dart';

import 'package:careshare/task_manager/presenter/task_widgets/display_comments_widget.dart';
import 'package:careshare/task_manager/presenter/task_widgets/effort_widget.dart';
import 'package:careshare/task_manager/presenter/task_widgets/notes_widget.dart';
import 'package:careshare/task_manager/presenter/task_widgets/priority_widget.dart';

import 'package:careshare/task_manager/presenter/task_widgets/task_input_field_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TaskDetailedView extends StatelessWidget {
  final CareTask task;

  const TaskDetailedView({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Task Details')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                return Wrap(
                  runSpacing: 24,
                  children: [
                    TaskInputFieldWidget(
                      label: 'Title',
                      style: Theme.of(context).textTheme.headline6,
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
                    SizedBox(
                        width: double.infinity, child: NotesWidget(task: task)),
                    CategoryWidget(task: task),
                    SizedBox(
                        width: double.infinity,
                        child: PriorityWidget(task: task)),
                    EffortWidget(task: task),
                    Row(
                      children: [
                        ProfilePhotoWidget(id: task.createdBy),
                        const SizedBox(width: 16),
                        Text(
                          'Created by: ${BlocProvider.of<ProfileCubit>(context).getName(task.createdBy)} on ${DateFormat('E').add_jm().format(task.dateCreated)}',
                        ),
                      ],
                    ),
                    AcceptATask(
                      task: task,
                    ),
                    DisplayCommentsWidget(task: task),
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
                            final taskCubit =
                                BlocProvider.of<TaskCubit>(context);

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
      ),
    );
  }
}
