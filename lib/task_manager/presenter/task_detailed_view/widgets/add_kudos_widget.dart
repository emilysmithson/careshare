import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:careshare/task_manager/models/task.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/kudos.dart';
import 'package:collection/collection.dart';
import '../../../models/task_status.dart';

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
    Profile profile = BlocProvider.of<ProfileCubit>(context).myProfile;
    _onTap() async {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('kudos');
      print("profile name: " + profile.name);
      final resp = await callable.call(<String, dynamic>{
        'task_id': task.id,
        'task_title': task.title,
        'kudos_giver_id': profile.id!,
        'kudos_giver_name': profile.name,
        'date_time': DateTime.now().toString()
      });
      print("result: ${resp.data}");

      // BlocProvider.of<TaskCubit>(context).editTask(
      //   task: task,
      //   newValue: Kudos(
      //     id: profile.id!,
      //     dateTime: DateTime.now(),
      //   ),
      //   taskField: TaskField.kudos,
      // );
      // BlocProvider.of<ProfileCubit>(context).addKudos(task.completedBy!);
    }

    Kudos? kudos =
        task.kudos?.firstWhereOrNull((element) => element.id == profile.id);

    if (kudos != null) {
      return Container();
      // return Row(
      //   children: [
      //     const Icon(Icons.star, size: 16),
      //     const SizedBox(width: 2),
      //     Text(task.kudos?.length.toString() ?? '0',
      //         style: Theme.of(context).textTheme.bodySmall),
      //     Text(' Kudos', style: Theme.of(context).textTheme.bodySmall)
      //   ],
      // );
    }

    return ElevatedButton.icon(
      onPressed: _onTap,
      icon: const Icon(Icons.star),
      label: const Text('Give Kudos'),
    );
  }
}
