import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:cloud_functions/cloud_functions.dart';

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
            onTap: () async {

              // only allow tasks in the following statuses to be assigned:
              // draft, created, assigned
              if (widget.task.taskStatus == TaskStatus.draft
              || widget.task.taskStatus == TaskStatus.created
              || widget.task.taskStatus == TaskStatus.assigned
              ) {

                Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

                BlocProvider.of<TaskCubit>(context).assignTask(task: widget.task, assignedToId: profile.id!, assignedById: myProfile.id!);

                // if  the task isn't in draft and the task isn't assigned to me, send a message to the assignee...
print('myProfile.id: ${myProfile.id}');
print('profile.id: ${profile.id}');

                if (widget.task.taskStatus != TaskStatus.draft &&
                    myProfile.id != profile.id) {
                  HttpsCallable callable =
                  FirebaseFunctions.instance.httpsCallable('assignTask');
                  // print("profile name: " + profile.name);
                  final resp = await callable.call(<String, dynamic>{
                    'task_id': widget.task.id,
                    'task_title': widget.task.title,
                    'assigner_id': myProfile.id,
                    'assigner_name': myProfile.name,
                    'assignee_id': profile.id!,
                    'assignee_name': profile.name,
                    'date_time': DateTime.now().toString()
                  });
                }
              }

            },
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                return Container(

                  padding: const EdgeInsets.all(8),
                  width: 80,
                  decoration: profile.id == widget.task.assignedTo
                      ? BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(),
                        )
                      : null,
                  child: Column(

                    children: [
                      ProfilePhotoWidget(
                        id: profile.id!,
                      ),
                      Text(profile.name, textAlign: TextAlign.center,)
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
          Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;
          BlocProvider.of<TaskCubit>(context).assignTask(task: widget.task, assignedToId: '', assignedById: myProfile.id!);
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
