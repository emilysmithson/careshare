import 'package:careshare/task_manager/domain/models/task.dart';
import 'package:careshare/task_manager/domain/usecases/all_task_usecases.dart';
import 'package:careshare/task_manager/presenter/task_widgets/task_input_field_widget.dart';
import 'package:careshare/task_manager/presenter/task_widgets/task_title_widget.dart';
import 'package:flutter/material.dart';

class TaskView extends StatefulWidget {
  final CareTask task;
  const TaskView({Key? key, required this.task}) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late CareTask task;
  @override
  void initState() {
    task = widget.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              TaskInputFieldWidget(
                label: 'Title',
                maxLines: 1,
                currentValue: task.title,
                task: task,
                onChanged: (value) {
                  AllTaskUseCases.editTaskTitle(
                    task: widget.task,
                    title: value,
                  );
                },
              ),
              const SizedBox(height: 16),
              TaskInputFieldWidget(
                label: 'Description',
                maxLines: 5,
                currentValue: task.details,
                task: task,
                onChanged: (value) {
                  AllTaskUseCases.editTaskField(
                      task: widget.task,
                      value: value,
                      taskField: TaskField.details);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
