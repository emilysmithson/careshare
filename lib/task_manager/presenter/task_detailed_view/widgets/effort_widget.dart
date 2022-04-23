import 'package:careshare/task_manager/models/task_effort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';

class EffortWidget extends StatelessWidget {
  final CareTask task;
  const EffortWidget({Key? key, required this.task}) : super(key: key);

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
                      BlocProvider.of<TaskCubit>(context).editTask(
                        task: task,
                        newValue: e.value,
                        taskField: TaskField.taskEffort,
                      );
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
                          effortIcon(e.value),
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

Widget effortIcon(int effort) {
  List<Widget> widgetList = [];
  for (int i = 0; i < 6; i++) {
    widgetList.add(
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.blue,
          ),
          color: i < effort ? Colors.blue : null,
        ),
        width: 5,
        height: 5 * (i + 1),
      ),
    );
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: widgetList,
  );
}
