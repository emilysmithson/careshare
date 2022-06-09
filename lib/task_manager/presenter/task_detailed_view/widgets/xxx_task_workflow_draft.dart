import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:careshare/profile_manager/models/profile.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TaskWorkflowDraftWidget extends StatelessWidget {
  final CareTask task;
  const TaskWorkflowDraftWidget({Key? key, required this.task})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<TaskCubit>(context).removeTask(task.id);

            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async {
            Profile myProfile =
                BlocProvider.of<MyProfileCubit>(context).myProfile;

            BlocProvider.of<TaskCubit>(context)
                .createTask(task: task, profileId: myProfile.id);

            Navigator.pop(context);

            // Send a message to tell the world the task is created
            HttpsCallable callable =
                FirebaseFunctions.instance.httpsCallable('createTask');
            await callable.call(<String, dynamic>{
              'task_id': task.id,
              'task_title': task.title,
              'creater_id': myProfile.id,
              'creater_name': myProfile.displayName,
              'date_time': DateTime.now().toString()
            });
          },
          child: const Text('Create Task'),
        ),
      ],
    );
  }
}
