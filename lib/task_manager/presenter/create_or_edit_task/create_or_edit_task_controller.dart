import 'package:flutter/material.dart';

import '../../domain/models/task.dart';
import '../../domain/models/task_type.dart';
import '../../domain/usecases/all_usecases.dart';
import '../task_entered/task_entered_screen.dart';

class CreateOrEditATaskController {
  final formKey = GlobalKey<FormState>();
  TaskType? taskType;
  bool isCreateTask = true;

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  initialiseControllers(CareTask? originalTask) {
    if (originalTask != null) {
      isCreateTask = false;
    }
    titleController = TextEditingController(
      text: originalTask?.title,
    );
    descriptionController = TextEditingController(
      text: originalTask?.description,
    );
    taskType = originalTask?.taskType;
  }

  createATask({
    required BuildContext context,
  }) {
    if (formKey.currentState!.validate()) {
      final CareTask task = CareTask(
        taskType: taskType!,
        title: titleController.text,
        description: descriptionController.text,
        dateCreated: DateTime.now(),
      );
      if (isCreateTask) {
        TasksUseCases.createATask(task);
      } else {
        TasksUseCases.editATask(task);
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
