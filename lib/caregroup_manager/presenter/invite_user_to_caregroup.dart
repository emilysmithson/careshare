import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class InviteUserToCaregroup {
  call(
      BuildContext context,
      ) {
    TextEditingController textEditingController = TextEditingController();
    onSubmit() async {
      if (textEditingController.text.isEmpty) {
        return;
      }
      final taskCubit = BlocProvider.of<TaskCubit>(context);
      final CareTask? task =
      await taskCubit.draftTask(textEditingController.text,'');
      if (task == null) {
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        textEditingController.clear();
      }
    }

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
                        'Invite someone to the Caregroup',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            label: Text('Enter an email address'),
                          ),
                          autofocus: true,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (value) {
                            onSubmit();
                          },
                        ),
                      ),
                      const SizedBox(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            label: Text('Select a role'),
                          ),
                          autofocus: true,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (value) {
                            onSubmit();
                          },
                        ),
                      ),
                      const SizedBox(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            label: Text('Add a message'),
                          ),
                          autofocus: true,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (value) {
                            onSubmit();
                          },
                        ),
                      ),
                      const SizedBox(height: 1),
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
                            child: const Text('Invite'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
