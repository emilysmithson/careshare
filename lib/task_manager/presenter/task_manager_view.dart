import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/presenter/tasks_overview.dart';
import 'package:careshare/widgets/careshare_appbar.dart';
import 'package:careshare/widgets/careshare_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'task_widgets/add_task_floating_action_button.dart';

class TaskManagerView extends StatefulWidget {
  const TaskManagerView({
    Key? key,
  }) : super(key: key);

  @override
  _TaskManagerViewState createState() => _TaskManagerViewState();
}

class _TaskManagerViewState extends State<TaskManagerView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
      if (state is TaskLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state is TaskLoaded) {
        if (state.careTaskList.isEmpty) {
          return const Center(
            child: Text('no tasks'),
          );
        }

        return TasksOverview(careTaskList: state.careTaskList);
      }

      return const Center(
        child: Text('Oops something went wrong'),
      );
    });
  }
}
