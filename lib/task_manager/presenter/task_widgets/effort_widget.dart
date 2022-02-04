import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/task_cubit.dart';
import '../../models/task.dart';

class EffortWidget extends StatelessWidget {
  final CareTask task;
  const EffortWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          child: Text('Effort: ${task.taskEffort.definition}'),
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<TaskCubit>(context),
                      child: BlocBuilder<TaskCubit, TaskState>(
                        builder: (context, state) {
                          return AlertDialog(
                            title:
                                Text('Effort: \n${task.taskEffort.definition}'),
                            content: SizedBox(
                              height: 40,
                              child: Slider(
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
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Ok'))
                            ],
                          );
                        },
                      ),
                    ));
          },
        ),
      ),
    );
    return Column(
      children: [
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
      ],
    );
  }
}
