import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../task_detailed_view.dart';

class AddTaskBottomSheet {
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
          await taskCubit.createTask(textEditingController.text);
      if (task == null) {
        Navigator.pop(context);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: BlocProvider.of<TaskCubit>(context),
                child: BlocProvider.value(
                  value: BlocProvider.of<ProfileCubit>(context),
                  child: BlocProvider.value(
                    value: BlocProvider.of<CategoriesCubit>(context),
                    child: TaskDetailedView(
                      task: task,
                    ),
                  ),
                )),
          ),
        );
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
                    'Create a new Task',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        label: Text('Enter your task name'),
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
                        child: const Text('Create'),
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
