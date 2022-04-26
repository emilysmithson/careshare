import 'package:careshare/task_manager/models/task_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';

class TypeWidget extends StatelessWidget {
  final CareTask task;
  const TypeWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        label: Text('Type'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: TaskType.taskTypeList
              .map(
                (e) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<TaskCubit>(context).editTask(
                        task: task,
                        newValue: e.value,
                        taskField: TaskField.taskType,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: task.taskType == e
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(),
                            )
                          : null,
                      child: Column(
                        children: [
                          Icon(
                            e.value == 1 ? Icons.holiday_village_outlined :
                            e.value ==2 ? Icons.settings_phone_sharp :
                            Icons.gps_fixed_sharp  ,
                            size: 30,
                            color: Colors.blueGrey,
                          ),
                          // Container(
                          //   height: 30,
                          //   width: 30,
                          //   decoration: BoxDecoration(
                          //     color: Colors.blue,
                          //     shape: BoxShape.circle,
                          //   ),
                          // ),
                          const SizedBox(height: 8),
                          Text(e.type),
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
