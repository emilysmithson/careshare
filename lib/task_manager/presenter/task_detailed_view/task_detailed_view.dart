import 'package:careshare/core/presentation/photo_and_name_widget.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/assign_a_task.dart';
import 'widgets/choose_category_widget.dart';
import 'widgets/display_comments_widget.dart';
import 'widgets/effort_widget.dart';
import 'widgets/priority_widget.dart';
import 'widgets/task_workflow_widget.dart';
import 'widgets/task_input_field_widget.dart';
import 'widgets/type_widget.dart';

class TaskDetailedView extends StatelessWidget {
  static const String routeName = "/task-detailed-view";
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
      child: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TaskWorkflowWidget(task: task),
              ],
            ),
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
                child: Wrap(
                  runSpacing: 24,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: TaskInputFieldWidget(
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
                    ),
                    PhotoAndNameWidget(
                      id: task.createdBy!,
                      text: 'Created by:',
                      dateTime: task.taskCreatedDate,
                    ),
                    TaskInputFieldWidget(
                        currentValue: task.details,
                        maxLines: 5,
                        task: task,
                        label: 'Description',
                        onChanged: (value) {
                          BlocProvider.of<TaskCubit>(context)
                              .editTaskFieldRepository(
                            task: task,
                            newValue: value,
                            taskField: TaskField.details,
                          );
                        }),
                    PriorityWidget(
                      task: task,
                    ),

                    Row(
                      children: [
                        Text('Can be done remotely'),
                        Checkbox(
                            value: task.canBeRemote,
                            onChanged: (bool? value) {
                              BlocProvider.of<TaskCubit>(context)
                                  .editTaskFieldRepository(
                                task: task,
                                newValue: value,
                                taskField: TaskField.canBeRemote,
                              );
                            }

                        ),
                      ],
                    ),

                    // TypeWidget(
                    //   task: task,
                    // ),
                    EffortWidget(task: task),
                    ChooseCategoryWidget(task: task),
                    AssignATask(
                      task: task,
                    ),
                    DisplayCommentsWidget(task: task),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
