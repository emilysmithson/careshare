import 'package:careshare/task_manager/models/task.dart';

import 'package:careshare/task_manager/usecases/edit_task_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TaskTitleWidget extends StatefulWidget {
  final CareTask task;
  const TaskTitleWidget({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskTitleWidget> createState() => _TaskTitleWidgetState();
}

class _TaskTitleWidgetState extends State<TaskTitleWidget> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.task.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: () async {
        final editTaskField = EditTaskField();
        final result = editTaskField(
          task: widget.task,
          newValue: controller.text,
          taskField: TaskField.title,
        );
        if (kDebugMode) {
          print(result);
        }
      },
      decoration: const InputDecoration(
        label: Text('Title'),
      ),
    );
  }
}
