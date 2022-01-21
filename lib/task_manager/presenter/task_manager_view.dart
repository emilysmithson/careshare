import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view.dart';

import 'package:careshare/task_manager/presenter/tasks_overview.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const AddTaskFloatingActionButton(),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox),
              label: 'All Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.compare_outlined),
              label: 'Completed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.my_library_add),
              label: 'My Tasks',
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
        body: body);
  }

  Widget get body {
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
        switch (state.view) {
          case CareTaskView.overview:
            return TasksOverview(careTaskList: state.careTaskList);
          case CareTaskView.details:
            return TaskDetailedView(task: state.task!);
        }
      }

      return const Center(
        child: Text('Oops something went wrong'),
      );
    });
  }
}
