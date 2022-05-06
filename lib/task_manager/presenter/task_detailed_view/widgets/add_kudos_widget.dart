import 'package:careshare/notifications/domain/careshare_notification.dart';
import 'package:careshare/notifications/presenter/cubit/notifications_cubit.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:careshare/task_manager/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/task_cubit.dart';
import '../../../models/kudos.dart';
import 'package:collection/collection.dart';
import '../../../models/task_status.dart';
import 'package:intl/intl.dart';

class KudosWidget extends StatelessWidget {
  final CareTask task;
  KudosWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (task.taskStatus != TaskStatus.completed) {
      return Container();
    }

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        Profile profile = BlocProvider.of<ProfileCubit>(context).myProfile;
        Kudos? kudos =
            task.kudos?.firstWhereOrNull((element) => element.id == profile.id);

        if (kudos != null) {
          // I've already given kudos, so don't show the button
          return Container(
            decoration:
                BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  '* ${(task.kudos!.length * task.taskEffort.value).toString()}'),
            ),
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
              recipients: [task.assignedTo!],
            );

            BlocProvider.of<TaskCubit>(context).editTask(
              task: task,
              newValue: Kudos(
                id: profile.id!,
                dateTime: DateTime.now(),
              ),
              taskField: TaskField.kudos,
            );

            // Update the kudos in the task completer's profile
            Profile taskCompletedBy = BlocProvider.of<ProfileCubit>(context)
                .profileList
                .firstWhere((element) => element.id == task.assignedTo);

            BlocProvider.of<ProfileCubit>(context).giveKudos(
                profile: taskCompletedBy,
                caregroupId: task.caregroup,
                kudos: task.taskEffort.value);
          },
          child: const Text('Give Kudos'),
        );
      },
    );
  }
}
