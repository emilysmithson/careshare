import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'task_widgets/task_summary_widget.dart';
import '../domain/models/task.dart';

import 'view_all_tasks_controller.dart';
import '../../widgets/custom_app_bar.dart';

class ViewAllTasksScreen extends StatefulWidget {
  const ViewAllTasksScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllTasksScreen> createState() => _ViewAllTasksScreenState();
}

class _ViewAllTasksScreenState extends State<ViewAllTasksScreen> {
  final controller = ViewAllTasksController();

  @override
  void initState() {
    controller.fetchTasks();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('All Tasks'),
      endDrawer: CustomDrawer(),
      // appBar: AppBar(
      //   title: const Text('All Tasks'),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => const CreateOrEditATaskScreen(),
      //             ),
      //           );
      //         },
      //         icon: const Icon(Icons.add))
      //   ],
      // ),
      body: ValueListenableBuilder(
        valueListenable: controller.status,
        builder: (context, status, _) {
          if (status == PageStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (status == PageStatus.error) {
            return const Center(child: Text('Couldn''t load tasks'));
          }
          return SingleChildScrollView(
            child: Column(
                children: controller.careTaskList.map((CareTask task) {
              return TaskSummaryWidget(task: task);
            }).toList()),
          );
        },
      ),
    );
  }
}
