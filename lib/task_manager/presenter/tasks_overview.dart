import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_widgets/task_section.dart';
import 'package:careshare/task_manager/presenter/task_widgets/task_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TasksOverview extends StatelessWidget {
  final List<CareTask> careTaskList;
  const TasksOverview({Key? key, required this.careTaskList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskSection(
            title: 'New Tasks',
            status: TaskStatus.created,
            careTaskList: careTaskList,
          ),
          TaskSection(
            title: 'My Tasks',
            status: TaskStatus.accepted,
            careTaskList: careTaskList,
          ),
          TaskSection(
            title: 'Completed Tasks',
            status: TaskStatus.completed,
            careTaskList: careTaskList,
          ),
        ],
      ),
    );
  }
}
