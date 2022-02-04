import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/models/task.dart';

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
    Profile profile = BlocProvider.of<ProfileCubit>(context).fetchMyProfile();
    _onTap() {
      BlocProvider.of<TaskCubit>(context).editTask(
        task: task,
        newValue: Kudos(
          id: profile.id!,
          dateTime: DateTime.now(),
        ),
        taskField: TaskField.kudos,
      );
    }

    Kudos? kudos =
        task.kudos?.firstWhereOrNull((element) => element.id == profile.id);

    if (task.completedBy == profile.id || kudos != null) {
      return Row(
        children: [
          const Icon(Icons.star),
          const SizedBox(width: 16),
          Text(task.kudos?.length.toString() ?? '0'),
          const Text(' Kudos')
        ],
      );
    }

    return ElevatedButton.icon(
      onPressed: _onTap,
      icon: const Icon(Icons.star),
      label: const Text('Give Kudos'),
    );
  }
}
