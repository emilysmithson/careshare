import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/comment.dart';
import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCommentWidget extends StatelessWidget {
  final CareTask task;
  AddCommentWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    onSubmit() {
      if (controller.text.isEmpty) {
        return;
      }
      Navigator.pop(context);
      Profile profile = BlocProvider.of<ProfileCubit>(context).myProfile;
      BlocProvider.of<TaskCubit>(context).editTask(
        task: task,
        newValue: Comment(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            commment: controller.text,
            createdBy: profile.id!,
            createdByDisplayName: profile.name,
            dateCreated: DateTime.now()),
        taskField: TaskField.comment,
      );
      controller.clear();
    }

    return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                  child: SafeArea(
                child: SizedBox(
                  height: 600,
                  child: Column(
                    children: [
                      Text(
                        'Add a comment',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            label: Text('Enter comment'),
                          ),
                          autofocus: true,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (value) {
                            onSubmit();
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: onSubmit,
                            child: const Text('Add comment'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ));
            });
      },
      icon: const Icon(Icons.add),
    );
  }
}
