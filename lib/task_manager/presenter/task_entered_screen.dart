import 'package:careshare/task_manager/presenter/task_widgets/task_detail_widget.dart';
import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';


import '../domain/models/task.dart';

class TaskEnteredScreen extends StatelessWidget {
  final CareTask task;
  const TaskEnteredScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Thank you for entering a task'),
      endDrawer: CustomDrawer(),
      body: TaskDetailWidget(task: task)


    );
  }
}
