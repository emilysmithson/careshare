import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AcceptATask extends StatefulWidget {
  final CareTask task;

  const AcceptATask({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  _AcceptATaskState createState() => _AcceptATaskState();
}

class _AcceptATaskState extends State<AcceptATask> {
  @override
  Widget build(BuildContext context) {
    final Profile profile =
        BlocProvider.of<ProfileCubit>(context).fetchMyProfile();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
              title: const Text('Accept this task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      widget.task.acceptedBy == null
                          ? ElevatedButton(
                              onPressed: () {
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
                                  newValue: TaskStatus.created,
                                  task: widget.task,
                                  taskField: TaskField.taskStatus,
                                );
                                Navigator.pop(context);
                              },
                              child: const Text('Accept task'),
                            )
                          : ElevatedButton(
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
          child: Row(
            children: [
              if (widget.task.acceptedBy != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ProfilePhotoWidget(id: widget.task.acceptedBy!),
                ),
              Text(widget.task.acceptedBy == null ||
                      widget.task.acceptedBy!.isEmpty ||
                      widget.task.acceptedOnDate == null
                  ? 'Accept this task'
                  : 'Assigned to: ${BlocProvider.of<ProfileCubit>(context).getName(widget.task.acceptedBy!)} on ${DateFormat('E').add_jm().format(widget.task.acceptedOnDate!)}'),
            ],
          ),
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
        child: SizedBox(
          width: 60,
          child: Column(
            children: [
              if (profile.photoURL != null)
                Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(profile.photoURL!),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              Text(profile.name)
            ],
          ),
        ));
  }
}