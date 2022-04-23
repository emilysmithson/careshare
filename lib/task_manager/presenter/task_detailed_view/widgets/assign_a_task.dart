import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

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
    List<Widget> widgetList = [];
    widgetList.addAll(BlocProvider.of<ProfileCubit>(context)
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
                  decoration: profile.id == widget.task.acceptedBy
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(),
                        )
                      : null,
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
        .toList());
    if (widget.task.acceptedBy != null && widget.task.acceptedBy!.isNotEmpty) {
      widgetList.add(GestureDetector(
        onTap: () {
          BlocProvider.of<TaskCubit>(context).assignTask(widget.task, null);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.grey[400],
                  child: const Icon(Icons.person, color: Colors.white)),
              const Text('Unassign'),
            ],
          ),
        ),
      ));
    }

    return InputDecorator(
      decoration: const InputDecoration(
        label: Text("Assign this task"),
      ),
      child: Wrap(children: widgetList),
    );
  }
}
