import 'package:careshare/core/presentation/photo_and_name_widget.dart';

import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';

import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/category_widget.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/complete_task_widget.dart';

import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/display_comments_widget.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/effort_widget.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/notes_widget.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/priority_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/accept_a_task.dart';
import 'widgets/task_input_field_widget.dart';

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
        appBar: AppBar(
          title: const Text('Task Details'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.delete,
              ),
              onPressed: () {
                final taskCubit = BlocProvider.of<TaskCubit>(context);

                taskCubit.removeTask(task.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
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
                    if (task.category != null) CategoryWidget(task: task),
                    SizedBox(
                        width: double.infinity,
                        child: PriorityWidget(task: task)),
                    EffortWidget(task: task),
                    PhotoAndNameWidget(
                        id: task.createdBy,
                        text: 'Created by:',
                        dateTime: task.dateCreated),
                    if (task.taskStatus == TaskStatus.accepted)
                      AcceptATask(
                        task: task,
                      ),
                    DisplayCommentsWidget(task: task),
                    Row(
                      children: [
                        if (task.category != null)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        if (task.category == null)
                          CategoryWidget(
                            task: task,
                            showButton: true,
                          ),
                        const Spacer(),
                        if (task.taskStatus == TaskStatus.created)
                          AcceptATask(
                            task: task,
                            showButton: true,
                          ),
                        if (task.taskStatus == TaskStatus.accepted)
                          CompleteTaskWidget(task: task),
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
