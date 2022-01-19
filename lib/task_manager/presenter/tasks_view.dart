import 'package:careshare/profile/usecases/fetch_profiles.dart';
import 'package:careshare/task_manager/presenter/add_task_floating_action_button.dart';

import 'package:careshare/task_manager/usecases/fetch_tasks.dart';
import 'package:careshare/task_manager/presenter/task_widgets/task_summary.dart';

import 'package:flutter/material.dart';

class TasksView extends StatefulWidget {
  final FetchProfiles profileModule;
  final FetchTasks taskManagerModule;
  const TasksView({
    Key? key,
    required this.profileModule,
    required this.taskManagerModule,
  }) : super(key: key);

  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  // final controller = TasksViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AddTaskFloatingActionButton(
          profileModule: widget.profileModule,
        ),
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
    return SafeArea(
      child: ValueListenableBuilder(
          valueListenable: widget.taskManagerModule.careTaskList,
          builder: (context, careTaskList, _) {
            if (widget.taskManagerModule.careTaskList.value.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                children: widget.taskManagerModule.careTaskList.value
                    .map(
                      (task) => TaskSummary(
                        task: task,
                        profileModule: widget.profileModule,
                      ),
                    )
                    .toList(),
              ),
            );
          }),
    );
  }
}
