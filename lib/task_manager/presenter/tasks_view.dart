import 'package:careshare/profile/profile_module.dart';
import 'package:careshare/task_manager/presenter/add_task_floating_action_button.dart';
import 'package:careshare/task_manager/presenter/tasks_view_controller.dart';
import 'package:careshare/widgets/task_summary.dart';

import 'package:flutter/material.dart';

class TasksView extends StatefulWidget {
  final ProfileModule profileModule;
  const TasksView({Key? key, required this.profileModule}) : super(key: key);

  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final controller = TasksViewController();

  @override
  void initState() {
    controller.fetchTasks();
    super.initState();
  }

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
      body: ValueListenableBuilder(
          valueListenable: controller.status,
          builder: (context, status, widget) {
            return body;
          }),
    );
  }

  Widget get body {
    switch (controller.status.value) {
      case PageStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case PageStatus.error:
        return const Center(child: Text('Something went wrong'));
      case PageStatus.loaded:
        return SafeArea(
          child: ValueListenableBuilder(
              valueListenable: controller.careTaskList,
              builder: (context, careTaskList, _) {
                return Column(
                  children: controller.careTaskList.value
                      .map(
                        (task) => TaskSummary(
                          task: task,
                          profileModule: widget.profileModule,
                        ),
                      )
                      .toList(),
                );
              }),
        );
    }
  }
}
