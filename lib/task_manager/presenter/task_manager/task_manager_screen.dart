import 'package:flutter/material.dart';

import '../../../style/style.dart';
import '../../../widgets/item_widget.dart';
import '../../domain/models/task.dart';
import '../create_or_edit_task/create_or_edit_task_screen.dart';
import 'task_manager_controller.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({Key? key}) : super(key: key);

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateOrEditATaskScreen(),
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
          return SingleChildScrollView(
            child: Column(
                children: controller.careTaskList.map((CareTask task) {
              return Container(
                margin: const EdgeInsets.all(16),
                decoration: Style.boxDecoration,
                child: Column(
                  children: [
                    itemWidget(
                      title: 'title',
                      content: task.title,
                      trailing: IconButton(
                        onPressed: () {
                          controller.removeATask(task.id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                    itemWidget(
                      title: 'description',
                      content: task.description,
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateOrEditATaskScreen(
                                task: task,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    itemWidget(
                      title: 'Type',
                      content: task.taskType.type,
                    ),
                  ],
                ),
              );
            }).toList()),
          );
        },
      ),
    );
  }
}
