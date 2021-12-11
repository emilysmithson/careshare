import 'package:careshare/task_manager/presenter/create_a_task/create_a_task_screen.dart';
import 'package:flutter/material.dart';

import '../../../widgets/item_widget.dart';
import '../../domain/models/task.dart';
import 'task_manager_controller.dart';

class TaskManagerScreen extends StatefulWidget {
  TaskManagerScreen({Key? key}) : super(key: key);

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final controller = TaskManagerController();

  @override
  void initState() {
    controller.fetchTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateATaskScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: controller.status,
        builder: (context, status, _) {
          if (status == PageStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (status == PageStatus.error) {
            return const Center(child: Text('Oh dear'));
          }
          return Column(
              children: controller.careTaskList.map((CareTask task) {
            return Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  itemWidget('title', task.title),
                  itemWidget('description', task.description),
                ],
              ),
            );
          }).toList());
        },
      ),
    );
  }
}
