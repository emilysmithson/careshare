import 'package:careshare/task_manager/domain/models/task.dart';
import 'package:careshare/task_manager/domain/usecases/all_task_usecases.dart';
import 'package:flutter/material.dart';

class TaskTitleWidget extends StatefulWidget {
  final CareTask task;
  TaskTitleWidget({Key? key, required this.task}) : super(key: key);

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
        final result = await AllTaskUseCases.editTaskField(
          task: widget.task,
          value: controller.text,
          taskField: TaskField.title,
        );
        print(result);
      },
      decoration: const InputDecoration(
        label: Text('Title'),
      ),
    );
  }
}
