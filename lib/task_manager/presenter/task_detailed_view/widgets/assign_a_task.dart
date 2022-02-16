import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

import '../../../../core/presentation/photo_and_name_widget.dart';

class AssignATask extends StatefulWidget {
  final CareTask task;
  final bool showButton;

  const AssignATask({Key? key, required this.task, this.showButton = false})
      : super(key: key);

  @override
  _AssignATaskState createState() => _AssignATaskState();
}

class _AssignATaskState extends State<AssignATask> {
  @override
  Widget build(BuildContext context) {
    final Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

    if (widget.showButton) {
      return ElevatedButton(
        onPressed: () {
          _showDialog(myProfile);
        },
        child: const Text('Assign this task'),
      );
    }
    return widget.task.acceptedBy != null && widget.task.acceptedOnDate != null
        ? GestureDetector(
            onTap: () {
              _showDialog(myProfile);
            },
            child: PhotoAndNameWidget(
                id: widget.task.acceptedBy!,
                text: 'Assigned to:',
                dateTime: widget.task.acceptedOnDate!))
        : ElevatedButton(
            child: const Text('Assign this task'),
            onPressed: () {
              _showDialog(myProfile);
            });
  }

  _showDialog(Profile myProfile) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<TaskCubit>(context),
        child: BlocProvider.value(
          value: BlocProvider.of<ProfileCubit>(context),
          child: AlertDialog(
              title: const Text('Assign this task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                      children: BlocProvider.of<ProfileCubit>(context)
                          .profileList
                          .map(
                            (profile) => GestureDetector(
                              onTap: () {
                                BlocProvider.of<TaskCubit>(context)
                                    .assignTask(widget.task, profile.id);
                              },
                              child: BlocBuilder<TaskCubit, TaskState>(
                                builder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    width: 80,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: profile.id ==
                                                    widget.task.acceptedBy
                                                ? Colors.blue
                                                : Colors.white)),
                                    child: Column(
                                      children: [
                                        ProfilePhotoWidget(
                                          id: profile.id!,
                                        ),
                                        Text(profile.name)
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                          .toList()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (widget.task.acceptedBy != null ||
                          widget.task.acceptedBy!.isNotEmpty)
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<TaskCubit>(context)
                                .assignTask(widget.task, null);
                          },
                          child: const Text('Unassign'),
                        ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
