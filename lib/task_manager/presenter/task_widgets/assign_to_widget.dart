import 'package:careshare/profile/cubit/profile_cubit.dart';
import 'package:careshare/profile/models/profile.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AssignToWidget extends StatefulWidget {
  final CareTask task;

  const AssignToWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  _AssignToWidgetState createState() => _AssignToWidgetState();
}

class _AssignToWidgetState extends State<AssignToWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        List<Profile> profileList =
            BlocProvider.of<ProfileCubit>(context).profileList;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
              title: const Text('Assign this task to:'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                      children:
                          profileList.map((e) => profileWidget(e)).toList()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // unassign = assign to null
                          BlocProvider.of<TaskCubit>(context).editTask(
                            newValue: null,
                            task: widget.task,
                            taskField: TaskField.acceptedBy,
                          );
                          BlocProvider.of<TaskCubit>(context).editTask(
                            newValue: null,
                            task: widget.task,
                            taskField: TaskField.acceptedOnDate,
                          );
                          BlocProvider.of<TaskCubit>(context).editTask(
                            newValue: TaskStatus.created,
                            task: widget.task,
                            taskField: TaskField.taskStatus,
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Unassign'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  )
                ],
              )),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.task.acceptedBy == null ||
                  widget.task.acceptedBy!.isEmpty ||
                  widget.task.acceptedOnDate == null
              ? 'Assign this task...'
              : 'Assigned to: ${BlocProvider.of<ProfileCubit>(context).getName(widget.task.acceptedBy!)} on ${DateFormat('E').add_jm().format(widget.task.acceptedOnDate!)}'),
        ),
      ),
    );
  }

  Widget profileWidget(Profile profile) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<TaskCubit>(context).editTask(
          newValue: profile.id,
          task: widget.task,
          taskField: TaskField.acceptedBy,
        );
        BlocProvider.of<TaskCubit>(context).editTask(
          newValue: DateTime.now(),
          task: widget.task,
          taskField: TaskField.acceptedOnDate,
        );
        BlocProvider.of<TaskCubit>(context).editTask(
          newValue: TaskStatus.accepted,
          task: widget.task,
          taskField: TaskField.taskStatus,
        );
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        height: 70,
        width: 70,
        decoration: const BoxDecoration(
          color: Colors.yellow,
          shape: BoxShape.circle,
        ),
        child: Center(child: Text(profile.name)),
      ),
    );
  }
}
