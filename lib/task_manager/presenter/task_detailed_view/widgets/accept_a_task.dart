import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

import '../../../../core/presentation/photo_and_name_widget.dart';

class AcceptATask extends StatefulWidget {
  final CareTask task;
  final bool showButton;

  const AcceptATask({Key? key, required this.task, this.showButton = false})
      : super(key: key);

  @override
  _AcceptATaskState createState() => _AcceptATaskState();
}

class _AcceptATaskState extends State<AcceptATask> {
  @override
  Widget build(BuildContext context) {
    final Profile profile = BlocProvider.of<ProfileCubit>(context).myProfile;
    if (widget.showButton) {
      return ElevatedButton(
        onPressed: () {
          _showDialog(profile);
        },
        child: const Text('Accept this task'),
      );
    }
    return GestureDetector(
      onTap: () {
        _showDialog(profile);
      },
      child: Row(
        children: [
          widget.task.acceptedBy != null && widget.task.acceptedOnDate != null
              ? PhotoAndNameWidget(
                  id: widget.task.acceptedBy!,
                  text: 'Assigned to:',
                  dateTime: widget.task.acceptedOnDate!)
              : const Text('Accept this task'),
        ],
      ),
    );
  }

  _showDialog(Profile profile) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
          title: Text(
              widget.task.acceptedBy == null || widget.task.acceptedBy == ''
                  ? 'Accept this task'
                  : 'Unassign this task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  widget.task.acceptedBy == null || widget.task.acceptedBy == ''
                      ? ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<TaskCubit>(context)
                                .assignTask(widget.task, profile.id!);
                            Navigator.pop(context);
                          },
                          child: const Text('Accept task'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<TaskCubit>(context)
                                .assignTask(widget.task, null);
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
  }
}
