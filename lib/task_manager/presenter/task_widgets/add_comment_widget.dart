import 'package:careshare/profile/cubit/profile_cubit.dart';
import 'package:careshare/profile/models/profile.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/comment.dart';
import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCommentWidget extends StatelessWidget {
  final CareTask task;
  const AddCommentWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return TextField(
      decoration: const InputDecoration(
        label: Text(
          'Add a comment',
        ),
      ),
      onSubmitted: (value) {
        Profile profile =
            BlocProvider.of<ProfileCubit>(context).fetchMyProfile();
        BlocProvider.of<TaskCubit>(context).editTask(
          task: task,
          newValue: Comment(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              commment: value,
              createdBy: profile.id!,
              createdByDisplayName: profile.name,
              dateCreated: DateTime.now()),
          taskField: TaskField.comment,
        );
        controller.clear();
      },
    );
  }
}
