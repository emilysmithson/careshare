import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view.dart';

import 'package:careshare/task_manager/presenter/task_widgets/task_summary.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_task_floating_action_button.dart';

class TasksView extends StatefulWidget {
  const TasksView({
    Key? key,
  }) : super(key: key);

  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
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
      if (state is TaskLoading) {
        return const Center(
          child: Text('No tasks'),
        );
      }
      if (state is TaskLoaded) {
        return SingleChildScrollView(
          child: Column(
            children: state.careTaskList
                .map(
                  (task) => TaskSummary(
                    task: task,
                  ),
                )
                .toList(),
          ),
        );
      }
      if (state is TaskDetailsState) {
        return TaskDetailedView(
          task: state.task,
        );
      }
      return const Center(
        child: Text('Oops something went wrong'),
      );
    });
  }
}
