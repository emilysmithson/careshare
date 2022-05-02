import 'package:careshare/core/presentation/photo_and_name_widget.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TaskWorkflowDraftWidget extends StatelessWidget {
  final CareTask task;
  const TaskWorkflowDraftWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    return
      Row(
        children: [
          ElevatedButton(
            onPressed: ()  {
              BlocProvider.of<TaskCubit>(context)
                  .removeTask(task.id);

              Navigator.pop(context);

            },
            child: const Text('Cancel'),

          ),
          SizedBox(width:20),
          ElevatedButton(
            onPressed: () async {
              Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

              BlocProvider.of<TaskCubit>(context).createTask(
                task: task,
                id: myProfile.id!
              );

              Navigator.pop(context);

              // Send a message to tell the world the task is created
              HttpsCallable callable =
              FirebaseFunctions.instance.httpsCallable('createTask');
              final resp = await callable.call(<String, dynamic>{
                'task_id': task.id,
                'task_title': task.title,
                'creater_id': myProfile.id,
                'creater_name': myProfile.name,
                'date_time': DateTime.now().toString()
              });

            },
            child: const Text('Create Task'),

          ),
        ],
      );
  }
}
