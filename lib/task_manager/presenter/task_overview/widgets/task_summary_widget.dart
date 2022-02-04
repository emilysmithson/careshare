import 'package:flutter/material.dart';

import '../../../models/task.dart';

class TaskSummaryWidget extends StatefulWidget {
  final CareTask task;
  const TaskSummaryWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskSummaryWidget> createState() => _TaskSummaryWidgetState();
}

class _TaskSummaryWidgetState extends State<TaskSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
