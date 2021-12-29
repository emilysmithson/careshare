import 'package:flutter/material.dart';

import '../domain/models/priority.dart';
import '../domain/models/task.dart';
import '../domain/models/task_type.dart';
import '../domain/models/task_status.dart';
import '../domain/usecases/all_task_usecases.dart';
import 'task_entered_screen.dart';

class CreateOrEditATaskController {
  final formKey = GlobalKey<FormState>();
  TaskType? taskType;
  TaskStatus? taskStatus;
  bool isCreateTask = true;
  Priority priority = Priority.medium;

  late TextEditingController titleController;
  late TextEditingController detailsController;
  String? id;

  initialiseControllers(CareTask? originalTask) {
    if (originalTask != null) {
      isCreateTask = false;
      id = originalTask.id;
    }
    titleController = TextEditingController(
      text: originalTask?.title,
    );
    detailsController = TextEditingController(
      text: originalTask?.details,
    );
    taskType = originalTask?.taskType;
  }

  createATask({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      final CareTask task = CareTask(
        careFor: "careFor",
        taskType: taskType!,
        taskStatus: TaskStatus.created,
        title: titleController.text,
        details: detailsController.text,
        dateCreated: DateTime.now(),
        priority: priority,
      );
      if (isCreateTask) {
        final response = await AllTaskUseCases.createATask(task);
        response.fold((l) => null, (r) => task.id = r);
      } else {
        task.id = id;
        AllTaskUseCases.editATask(task);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskEnteredScreen(task: task),
        ),
      );
    }
  }
}
