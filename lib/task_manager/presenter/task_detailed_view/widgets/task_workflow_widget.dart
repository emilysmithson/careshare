import 'package:careshare/core/presentation/photo_and_name_widget.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/task_manager/models/kudos.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:careshare/notifications/domain/careshare_notification.dart';
import 'package:careshare/notifications/presenter/cubit/notifications_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/kudos.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class TaskWorkflowWidget extends StatelessWidget {
  final CareTask task;
  const TaskWorkflowWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    Profile profile = BlocProvider.of<ProfileCubit>(context).myProfile;

    return
      Row(
        children: [

          // We have the following buttons:
          //    Cancel - shown when status is Draft
          //    Create - shown when status is Draft
          //    Accept - shown when status is Assigned
          //    Complete - shown when status is Draft, Assigned or Accepted
          //    Give Kudos - shown when status is Complete


          // Cancel button
          // Shown when the task is in Draft
          // When clicked, the draft task is deleted
          if (task.taskStatus == TaskStatus.draft)
            ElevatedButton(
            onPressed: ()  {
              BlocProvider.of<TaskCubit>(context)
                  .removeTask(task.id);

              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          if (task.taskStatus == TaskStatus.draft)
            SizedBox(width:20),


          // Create Task button
          // Shown when the task is in Draft
          // When clicked, the status is set to:
          //    Created if task isn't assigned
          //    Assigned if the task is assigned to someone else
          //    Accepted if the task is assigned to me
          // A message is sent to everyone in the caregroup except me if the task is unassigned
          // A message is sent to the assignee if the task is assigned
          if (task.taskStatus == TaskStatus.draft)
          ElevatedButton(
            onPressed: () async {
              Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

              BlocProvider.of<TaskCubit>(context).createTask(
                task: task,
                id: myProfile.id!,
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
          if (task.taskStatus == TaskStatus.draft)
            SizedBox(width:20),

          // Accept Task Button
          // Shown when the task is Assigned
          if (task.taskStatus == TaskStatus.assigned && task.assignedTo == profile.id)
            ElevatedButton(
              onPressed: () async {
                Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;


                BlocProvider.of<TaskCubit>(context)
                    .acceptTask(
                  task: task,
                  id: myProfile.id!,
                );

                Navigator.pop(context);

                // Send a message to tell the world the task is accepted
                HttpsCallable callable =
                FirebaseFunctions.instance.httpsCallable('acceptTask');
                final resp = await callable.call(<String, dynamic>{
                  'task_id': task.id,
                  'task_title': task.title,
                  'accepter_id': myProfile.id,
                  'accepter_name': myProfile.name,
                  'date_time': DateTime.now().toString()
                });

              },
              child: const Text('Accept Task'),
            ),
          if (task.taskStatus == TaskStatus.assigned && task.assignedTo == profile.id)
            SizedBox(width:20),


          // Reject Task Button
          // Shown when the task is Assigned
          if (task.taskStatus == TaskStatus.assigned && task.assignedTo == profile.id)
            ElevatedButton(
              onPressed: () async {
                Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

                BlocProvider.of<TaskCubit>(context)
                    .rejectTask(
                  task: task,
                  id: myProfile.id!,
                );

                Navigator.pop(context);

                // Send a message to tell the world the task is accepted
                HttpsCallable callable =
                FirebaseFunctions.instance.httpsCallable('rejectTask');
                final resp = await callable.call(<String, dynamic>{
                  'task_id': task.id,
                  'task_title': task.title,
                  'accepter_id': myProfile.id,
                  'accepter_name': myProfile.name,
                  'date_time': DateTime.now().toString()
                });

              },
              child: const Text('Reject Task'),
            ),
          if (task.taskStatus == TaskStatus.assigned && task.assignedTo == profile.id)
            SizedBox(width:20),


          // Complete Task button
          // Shown when the task is in
          //    Accepted and the task is assigned to me
          // When clicked, the status is set to: Completed
          // A message is sent to everyone in the caregroup except me
          if (task.assignedTo == profile.id && task.taskStatus == TaskStatus.accepted)
            ElevatedButton(
              onPressed: () async {
                Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

                BlocProvider.of<TaskCubit>(context).completeTask(
                  task: task,
                  id: myProfile.id!,
                  dateTime: DateTime.now()
                );

                Navigator.pop(context);

                // Send a message to tell the world the task is complete
                HttpsCallable callable =
                FirebaseFunctions.instance.httpsCallable('completeTask');
                final resp = await callable.call(<String, dynamic>{
                  'task_id': task.id,
                  'task_title': task.title,
                  'completer_id': myProfile.id,
                  'completer_name': myProfile.name,
                  'date_time': DateTime.now().toString()
                });

              },
              child: const Text('Mark Complete'),
            ),
          if (task.assignedTo == profile.id && task.taskStatus == TaskStatus.accepted)
            SizedBox(width:20),




          // Complete Task button
          // Shown when the task is in
          //    Accepted and the task is assigned to me
          // When clicked, the status is set to: Completed
          // A message is sent to everyone in the caregroup except me
          // if (task.assignedTo == profile.id && task.taskStatus == TaskStatus.accepted)
          // ElevatedButton(
          //   onPressed: () {},
          //   child: GestureDetector(
          //     onTap: () {
          //       showDialog(
          //         context: context,
          //         builder: (_) => BlocProvider.value(
          //           value: BlocProvider.of<TaskCubit>(context),
          //           child: BlocProvider.value(
          //             value: BlocProvider.of<ProfileCubit>(context),
          //             child: BlocBuilder<TaskCubit, TaskState>(
          //               builder: (context, state) {
          //                 return Dialog(
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Wrap(
          //                       runSpacing: 16,
          //                       children: [
          //                         SizedBox(
          //                           width: double.infinity,
          //                           child: Center(
          //                             child: Text(
          //                               'Mark as Complete',
          //                               style: Theme.of(context).textTheme.headline6,
          //                             ),
          //                           ),
          //                         ),
          //                         Text(
          //                           'Completed: ',
          //                           style: Theme.of(context).textTheme.subtitle1,
          //                         ),
          //                         SizedBox(
          //                           height: 120,
          //                           child: CupertinoDatePicker(
          //                             onDateTimeChanged: (DateTime dateTime) {
          //                               dateTime = dateTime;
          //                             },
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           width: double.infinity,
          //                           child: Align(
          //                             alignment: Alignment.bottomRight,
          //                             child: ElevatedButton(
          //                               onPressed: ()  async {
          //
          //                                 Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;
          //
          //
          //                                 BlocProvider.of<TaskCubit>(context)
          //                                     .completeTask(
          //                                   task: task,
          //                                   id: myProfile.id!,
          //                                   dateTime: dateTime,
          //                                 );
          //
          //                                 Navigator.pop(context);
          //
          //
          //                                 // Send a message to tell the world the task is complete
          //                                 HttpsCallable callable =
          //                                 FirebaseFunctions.instance.httpsCallable('completeTask');
          //                                 final resp = await callable.call(<String, dynamic>{
          //                                   'task_id': task.id,
          //                                   'task_title': task.title,
          //                                   'completer_id': myProfile.id,
          //                                   'completer_name': myProfile.name,
          //                                   'date_time': DateTime.now().toString()
          //                                 });
          //
          //
          //                               },
          //                               child: const Text('Ok'),
          //                             ),
          //                           ),
          //                         )
          //                       ],
          //                     ),
          //                   ),
          //                 );
          //               },
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //     child: const Text('Mark as complete'),
          //   ),
          // ),
          // if (task.assignedTo == profile.id && task.taskStatus == TaskStatus.accepted)
          //   SizedBox(width:20),


          // Kudos
          // Shown when the task is Complete
          if (task.taskStatus == TaskStatus.completed)
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              Kudos? kudos =
              task.kudos?.firstWhereOrNull((element) => element.id == profile.id);

              if (kudos != null) {
                // I've already given kudos, so don't show the button
                return ElevatedButton(
                  onPressed: (){},
                  child: Text('* ${task.kudos!.length.toString()}'),
                );
              }
              return ElevatedButton(
                onPressed: () async {
                  final String id = DateTime.now().millisecondsSinceEpoch.toString();
                  final DateTime dateTime = DateTime.now();
                  final kudosNotification = CareshareNotification(
                      id: id,
                      title:
                      "${BlocProvider.of<ProfileCubit>(context).myProfile.name} has given you kudos for completing ${task.title}",
                      routeName: "/task-detailed-view",
                      subtitle:
                      'on ${DateFormat('E d MMM yyyy').add_jm().format(dateTime)}',
                      dateTime: dateTime,
                      senderId: FirebaseAuth.instance.currentUser!.uid,
                      isRead: false,
                      arguments: task.id);

                  BlocProvider.of<NotificationsCubit>(context).sendNotifcations(
                    notification: kudosNotification,
                    recipients: [task.acceptedBy!],
                  );

                  // Add a kudos record to the profile/kudos
                  BlocProvider.of<TaskCubit>(context).editTask(
                    task: task,
                    newValue: Kudos(
                      id: profile.id!,
                      dateTime: DateTime.now(),
                    ),
                    taskField: TaskField.kudos,
                  );

                  BlocProvider.of<ProfileCubit>(context).addKudos(task.completedBy!);
                },
                child: const Text('Give Kudos'),
              );
            },
          ),
          if (task.taskStatus == TaskStatus.completed)
            SizedBox(width:20),

        ],
      );
  }
}
