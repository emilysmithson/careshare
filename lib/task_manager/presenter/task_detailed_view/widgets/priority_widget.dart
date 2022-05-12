import 'package:careshare/task_manager/models/task_priority.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';

class PriorityWidget extends StatelessWidget {
  final CareTask task;
  final bool enabled;

  const PriorityWidget({Key? key,
    required this.task,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        label: Text('Priority'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: TaskPriority.priorityList
              .map(
                (e) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                        if (enabled) {
                          BlocProvider.of<TaskCubit>(context).editTask(
                            task: task,
                            newValue: e.value,
                            taskField: TaskField.taskPriority,
                          );
                        }
                      },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: task.taskPriority == e
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(),
                            )
                          : null,
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: e.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(e.level),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
