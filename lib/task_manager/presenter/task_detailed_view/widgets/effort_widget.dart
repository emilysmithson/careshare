import 'package:careshare/task_manager/models/task_effort.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/effort_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';

class EffortWidget extends StatelessWidget {
  final CareTask task;
  final bool locked;

  const EffortWidget({Key? key,
    required this.task,
    this.locked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        label: Text('Effort'),
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: TaskEffort.taskSizeList
              .map((e) => Expanded(
                      child: GestureDetector(
                    onTap: () {
                      if (!locked) {
                        BlocProvider.of<TaskCubit>(context).editTask(
                          task: task,
                          newValue: e.value,
                          taskField: TaskField.taskEffort,
                        );
                      }
                    },
                    child: Container(
                      decoration: task.taskEffort == e
                          ? BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2)),
                            )
                          : null,
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          EffortIcon(effort: e.value),
                          const SizedBox(height: 4),
                          Text(
                            e.definition,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )))
              .toList()),
    );
  }
}
