import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/task_manager/models/kudos.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:careshare/profile_manager/models/profile.dart';
import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:careshare/notification_manager/models/careshare_notification.dart';
import 'package:careshare/notification_manager/cubit/notifications_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';

import '../../../models/kudos.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class TaskWorkflowWidget extends StatelessWidget {
  final CareTask task;
  final formKey;

  const TaskWorkflowWidget({Key? key, required this.task, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;

    return Row(
      children: [
        // We have the following buttons:
        //    Cancel - shown when status is Draft
        //    Create - shown when status is Draft
        //    Accept - shown when status is Assigned
        //    Complete - shown when status is Draft, Assigned or Accepted
        //    Give Kudos - shown when status is Complete

        // // Cancel button
        // // Shown when the task is in Draft
        // // When clicked, the draft task is deleted
        // if (task.taskStatus == TaskStatus.draft)
        //   ElevatedButton(
        //     onPressed: () {
        //       BlocProvider.of<TaskCubit>(context).removeTask(task.id);
        //
        //       Navigator.pop(context);
        //     },
        //     child: const Text('Cancel'),
        //   ),
        if (task.taskStatus == TaskStatus.draft) const SizedBox(width: 20),

        //     // Create Task button
        //     // Shown when the task is in Draft
        //     // When clicked, the status is set to:
        //     //    Created if task isn't assigned
        //     //    Assigned if the task is assigned to someone else
        //     //    Accepted if the task is assigned to me
        //     // A message is sent to everyone in the caregroup except me if the task is unassigned
        //     // A message is sent to the assignee if the task is assigned
        //     if (task.taskStatus == TaskStatus.draft)
        //       ElevatedButton(
        //         onPressed: () async {
        //
        // if (this.formKey.currentState!.validate()) {
        //   print('validated');
        // }
        //
        //
        //           BlocProvider.of<TaskCubit>(context).createTask(
        //             task: task,
        //             id: myProfile.id,
        //           );
        //
        //           Navigator.pop(context);
        //
        //           // Send a message to tell the world the task is created
        //           HttpsCallable callable =
        //               FirebaseFunctions.instance.httpsCallable('createTask');
        //           await callable.call(<String, dynamic>{
        //             'task_id': task.id,
        //             'task_title': task.title,
        //             'creater_id': myProfile.id,
        //             'creater_name': myProfile.name,
        //             'date_time': DateTime.now().toString()
        //           });
        //         },
        //         child: const Text('Create Task'),
        //       ),
        //     if (task.taskStatus == TaskStatus.draft) const SizedBox(width: 20),

        // // Accept Task Button
        // // Shown when the task is Assigned
        // if (task.taskStatus == TaskStatus.assigned &&
        //     task.assignedTo == profile.id)
        //   ElevatedButton(
        //     onPressed: () async {
        //
        //       BlocProvider.of<TaskCubit>(context).acceptTask(
        //         task: task,
        //         id: myProfile.id,
        //       );
        //
        //       Navigator.pop(context);
        //
        //       // Send a message to tell the world the task is accepted
        //       HttpsCallable callable =
        //           FirebaseFunctions.instance.httpsCallable('acceptTask');
        //       await callable.call(<String, dynamic>{
        //         'task_id': task.id,
        //         'task_title': task.title,
        //         'accepter_id': myProfile.id,
        //         'accepter_name': myProfile.name,
        //         'date_time': DateTime.now().toString()
        //       });
        //     },
        //     child: const Text('Accept Task'),
        //   ),
        // if (task.taskStatus == TaskStatus.assigned &&
        //     task.assignedTo == profile.id)
        //   const SizedBox(width: 20),

        // Reject Task Button
        // Shown when the task is Assigned
        if (task.taskStatus == TaskStatus.assigned && task.assignedTo == myProfile.id)
          ElevatedButton(
            onPressed: () async {
              BlocProvider.of<TaskCubit>(context).rejectTask(
                task: task,
                profileId: myProfile.id,
              );

              Navigator.pop(context);

              // Send a message to tell the world the task is accepted
              HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('rejectTask');
              await callable.call(<String, dynamic>{
                'task_id': task.id,
                'task_title': task.title,
                'accepter_id': myProfile.id,
                'accepter_name': myProfile.name,
                'date_time': DateTime.now().toString()
              });
            },
            child: const Text('Reject Task'),
          ),
        if (task.taskStatus == TaskStatus.assigned && task.assignedTo == myProfile.id) const SizedBox(width: 20),

        // Complete Task button
        // Shown when the task is in
        //    Accepted and the task is assigned to me
        // When clicked, the status is set to: Completed
        // A message is sent to everyone in the caregroup except me
        if (task.assignedTo == myProfile.id && task.taskStatus == TaskStatus.accepted)
          ElevatedButton(
            onPressed: () async {
              BlocProvider.of<TaskCubit>(context)
                  .completeTask(task: task, profileId: myProfile.id, dateTime: DateTime.now());

              // Update the completed count in the task completer's profile
              BlocProvider.of<MyProfileCubit>(context)
                  .completeTask(profile: myProfile, caregroupId: task.caregroupId, effort: task.taskEffort.value);

              Navigator.pop(context);

              // notify everyone except me
              final String id = DateTime.now().millisecondsSinceEpoch.toString();
              final DateTime dateTime = DateTime.now();

              final completionNotification = CareshareNotification(
                  id: id,
                  caregroupId: task.caregroupId,
                  title: "${myProfile.name} has completed task '${task.title}'",
                  routeName: "/task-detailed-view",
                  subtitle: 'on ${DateFormat('E d MMM yyyy').add_jm().format(dateTime)}',
                  dateTime: dateTime,
                  senderId: myProfile.id,
                  isRead: false,
                  arguments: task.id);

              List<String> recipientList = [];
              BlocProvider.of<AllProfilesCubit>(context).profileList.forEach((p) {
                if (p.id != myProfile.id) {
                  recipientList.add(p.id);
                }
              });

              BlocProvider.of<NotificationsCubit>(context).sendNotifications(
                notification: completionNotification,
                recipients: recipientList,
              );

              // // Send a message to tell the world the task is complete
              // HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('completeTask');
              // await callable.call(<String, dynamic>{
              //   'task_id': task.id,
              //   'task_title': task.title,
              //   'completer_id': myProfile.id,
              //   'completer_name': myProfile.name,
              //   'date_time': DateTime.now().toString()
              // });
            },
            child: const Text('Mark Complete'),
          ),

        if (task.assignedTo == myProfile.id && task.taskStatus == TaskStatus.accepted) const SizedBox(width: 20),

        if (task.taskStatus == TaskStatus.completed)
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              Kudos? kudos = task.kudos?.firstWhereOrNull((element) => element.id == myProfile.id);

              if (kudos != null) {
                // I've already given kudos, so don't show the button
                return ElevatedButton(
                  onPressed: () {},
                  child: Text('* ${(task.kudos!.length * task.taskEffort.value).toString()}'),
                );
              }
              return ElevatedButton(
                onPressed: () async {
                  final String id = DateTime.now().millisecondsSinceEpoch.toString();
                  final DateTime dateTime = DateTime.now();
                  final kudosNotification = CareshareNotification(
                      id: id,
                      caregroupId: task.caregroupId,
                      title: "${myProfile.name} has given you kudos for completing ${task.title}",
                      routeName: "/task-detailed-view",
                      subtitle: 'on ${DateFormat('E d MMM yyyy').add_jm().format(dateTime)}',
                      dateTime: dateTime,
                      senderId: myProfile.id,
                      isRead: false,
                      arguments: task.id);

                  BlocProvider.of<NotificationsCubit>(context).sendNotifications(
                    notification: kudosNotification,
                    recipients: [task.assignedTo!],
                  );

                  // Add a kudos record to the task/kudos
                  BlocProvider.of<TaskCubit>(context).editTask(
                    task: task,
                    newValue: Kudos(
                      id: myProfile.id,
                      dateTime: DateTime.now(),
                    ),
                    taskField: TaskField.kudos,
                  );

                  // Update the kudos in the task completer's profile
                  BlocProvider.of<MyProfileCubit>(context)
                      .giveKudos(profile: myProfile, caregroupId: task.caregroupId, kudos: task.taskEffort.value);
                },
                child: const Text('Give Kudos'),
              );
            },
          ),
        if (task.taskStatus == TaskStatus.completed) const SizedBox(width: 20),
      ],
    );
  }
}
