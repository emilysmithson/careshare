import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/task_cubit.dart';
import '../../models/task.dart';

class PriorityWidget extends StatelessWidget {
  final CareTask task;
  const PriorityWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'Priority: '),
            TextSpan(
              text: task.taskPriority.level,
              style: TextStyle(color: task.taskPriority.color),
            ),
          ],
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<TaskCubit>(context),
                  child: BlocBuilder<TaskCubit, TaskState>(
                    builder: (context, state) {
                      return AlertDialog(
                        title: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Priority: '),
                              TextSpan(
                                text: task.taskPriority.level,
                                style:
                                    TextStyle(color: task.taskPriority.color),
                              ),
                            ],
                          ),
                        ),
                        content: SizedBox(
                          height: 40,
                          child: Slider(
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
    );
  }
}
